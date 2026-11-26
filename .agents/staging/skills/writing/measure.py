#!/usr/bin/env python3
"""writing skill の指標を実測する。

usage:
  python3 measure.py <path>...            # 数値だけ出す。exit code は常に 0
  python3 measure.py -v <path>...         # 長文と括弧の中身を列挙する
  python3 measure.py --gate <path>...     # 閾値超過で exit 1 (opt-in)
  python3 measure.py --selftest           # fixture で自己検査

path はファイルでもディレクトリでもよい。ディレクトリは配下の *.md を対象にする。

既定は report-only である。閾値は診断であって合格判定ではないため、
exit code を completion の条件に使わない。詳細は SKILL.md を読むこと。

素朴に「句点で split して括弧を grep する」と壊れる。
Markdown の link destination や code span の括弧を補足括弧として数え、
空行や fence を跨いで複数の段落が 1 文に連結されるためである。
このスクリプトは Markdown の block と inline を落としてから散文だけを測る。
"""

import os
import re
import sys

LONG_SENTENCE = 60  # 文字

FENCE = re.compile(r"^(\s{0,3})(`{3,}|~{3,})(.*)$")
LIST_MARKER = re.compile(r"^\s*([-*+]|\d+[.)])\s")
TABLE = re.compile(r"^\s*\|")
ATX_HEADING = re.compile(r"^\s{0,3}#{1,6}(\s|$)")
SETEXT_UNDERLINE = re.compile(r"^\s{0,3}(=+|-{2,})\s*$")
HTML_BLOCK_START = re.compile(r"^\s{0,3}</?[a-zA-Z][a-zA-Z0-9-]*")
HTML_COMMENT = re.compile(r"<!--.*?-->", re.S)
BLOCKQUOTE = re.compile(r"^\s{0,3}>\s?")
MD_IMAGE = re.compile(r"!\[([^\]]*)\]\([^)]*(?:\([^)]*\)[^)]*)*\)")
MD_LINK = re.compile(r"\[([^\]]*)\]\([^)]*(?:\([^)]*\)[^)]*)*\)")
AUTOLINK = re.compile(r"<[a-z][a-z0-9+.-]*:[^>\s]*>", re.I)
BARE_URL = re.compile(r"https?://\S+")


def strip_code_spans(s: str) -> str:
    """CommonMark の code span を落とす。backtick の連続数は可変である。"""
    out: list[str] = []
    i = 0
    n = len(s)
    while i < n:
        if s[i] != "`":
            out.append(s[i])
            i += 1
            continue
        run = 0
        while i + run < n and s[i + run] == "`":
            run += 1
        closing = s.find("`" * run, i + run)
        # 同じ長さの閉じ backtick を探す。より長い run の一部なら code span ではない。
        while closing != -1:
            after = closing + run
            if after < n and s[after] == "`":
                closing = s.find("`" * run, after)
                continue
            break
        if closing == -1:
            out.append(s[i : i + run])
            i += run
            continue
        out.append(" ")
        i = closing + run
    return "".join(out)


def to_plain(s: str) -> str:
    """inline の Markdown を落として plain text にする。"""
    s = strip_code_spans(s)
    s = MD_IMAGE.sub(r"\1", s)
    s = MD_LINK.sub(r"\1", s)
    s = AUTOLINK.sub(" ", s)
    s = BARE_URL.sub(" ", s)
    return s


def count_bold(plain: str) -> int:
    """plain text 上の `**` の対を数える。code span 内の `**` は既に落ちている。"""
    return plain.count("**") // 2


def matched_parens(plain: str) -> list[str]:
    """対応の取れた括弧の中身だけを返す。閉じない括弧は数えない。"""
    text = plain.replace("**", "")
    found: list[str] = []
    stack: list[int] = []
    for i, ch in enumerate(text):
        if ch == "(":
            stack.append(i)
        elif ch == ")" and stack:
            start = stack.pop()
            if not stack:
                found.append(text[start + 1 : i])
    return found


class Block:
    def __init__(self, text: str, line: int) -> None:
        self.text = text
        self.line = line


def blocks_of(text: str) -> tuple[list[Block], int]:
    """散文の block 一覧と散文の行数を返す。

    frontmatter / fence / HTML block / 表 / 見出し / HTML comment は散文に数えない。
    空行、箇条書きの項目の開始、blockquote の空行は block の境界にする。
    """
    text = HTML_COMMENT.sub(" ", text)
    lines = text.split("\n")

    blocks: list[Block] = []
    current: list[str] = []
    start_line = 0
    prose_lines = 0

    in_front = False
    fence_char: str | None = None
    fence_len = 0
    in_html = False

    def flush() -> None:
        nonlocal current
        if current:
            blocks.append(Block(" ".join(current), start_line))
            current = []

    for i, raw in enumerate(lines):
        s = raw.strip()

        if i == 0 and s == "---":
            in_front = True
            continue
        if in_front:
            if s == "---":
                in_front = False
            continue

        m = FENCE.match(raw)
        if fence_char is None and m:
            fence_char = m.group(2)[0]
            fence_len = len(m.group(2))
            flush()
            continue
        if fence_char is not None:
            # 閉じ fence は同じ文字で、開き以上の長さで、info string を持たない。
            if m and m.group(2)[0] == fence_char and len(m.group(2)) >= fence_len and not m.group(3).strip():
                fence_char = None
            continue

        if in_html:
            if not s:
                in_html = False
                flush()
            continue
        if HTML_BLOCK_START.match(raw) and not AUTOLINK.match(s):
            flush()
            in_html = True
            continue

        quoted = BLOCKQUOTE.match(raw)
        if quoted:
            body = raw[quoted.end() :]
            if not body.strip():
                flush()
                continue
            raw, s = body, body.strip()

        if not s or TABLE.match(raw) or ATX_HEADING.match(raw):
            flush()
            continue

        # setext 見出しは「次行が下線」で判定する。下線自体も散文に数えない。
        if SETEXT_UNDERLINE.match(raw):
            flush()
            continue
        nxt = lines[i + 1].strip() if i + 1 < len(lines) else ""
        if nxt and SETEXT_UNDERLINE.match(nxt) and not LIST_MARKER.match(raw):
            flush()
            continue

        prose_lines += 1

        if LIST_MARKER.match(raw):
            flush()
            start_line = i + 1
            current = [s]
        else:
            if not current:
                start_line = i + 1
            current.append(s)

    flush()
    return blocks, prose_lines


def sentences_of(blocks: list[Block]) -> list[Block]:
    """block を句点で文に割る。block を跨いで連結しない。"""
    out: list[Block] = []
    for b in blocks:
        plain = to_plain(b.text).replace("**", "")
        for part in re.split(r"。", plain):
            part = part.strip()
            if part:
                out.append(Block(part, b.line))
    return out


def stats(text: str) -> dict:
    blocks, prose_lines = blocks_of(text)
    plains = [to_plain(b.text) for b in blocks]
    sents = sentences_of(blocks)
    parens: list[tuple[int, str]] = []
    for b, plain in zip(blocks, plains):
        for inner in matched_parens(plain):
            parens.append((b.line, inner))
    return {
        "prose_lines": prose_lines,
        "bold": sum(count_bold(p) for p in plains),
        "paren": len(parens),
        "parens": parens,
        "sentences": len(sents),
        "long": [s for s in sents if len(s.text) > LONG_SENTENCE],
    }


def measure(path: str, verbose: bool, gate: bool) -> bool:
    st = stats(open(path, encoding="utf-8").read())
    lines, sents = st["prose_lines"], st["sentences"]
    bold_max = max(1, lines // 10)
    paren_max = max(1, lines * 3 // 10)
    long_max = max(1, sents * 3 // 10)

    ok = st["bold"] <= bold_max and st["paren"] <= paren_max and len(st["long"]) <= long_max
    print(
        f"{path:<48} 散文 {lines:>4}行"
        f" / 太字 {st['bold']:>3}(<={bold_max:>3})"
        f" / 括弧 {st['paren']:>4}(<={paren_max:>4})"
        f" / 長文 {len(st['long']):>3}/{sents:<4}(<={long_max:>3})"
        f"  {'OK' if ok else 'OVER'}"
    )
    if verbose:
        for s in st["long"]:
            print(f"    long  {path}:{s.line}: {len(s.text)}字: {s.text[:80]}")
        for line, inner in st["parens"]:
            print(f"    paren {path}:{line}: ({inner[:68]})")
    return ok if gate else True


def expand(paths: list[str]) -> list[str]:
    """引数を *.md の一覧へ展開する。file と directory の重複は取り除く。"""
    out: list[str] = []
    seen: set[str] = set()
    for p in paths:
        found = []
        if os.path.isdir(p):
            for root, _dirs, files in os.walk(p):
                found.extend(os.path.join(root, f) for f in sorted(files) if f.endswith(".md"))
        else:
            found.append(p)
        for f in found:
            key = os.path.realpath(f)
            if key not in seen:
                seen.add(key)
                out.append(f)
    return out


FIXTURES: list[tuple[str, str, dict]] = [
    ("link と code span の括弧は数えない", "出典は [仕様](https://example.com/a(b)) にある。関数 `fn(a)` を呼ぶ。\n", {"paren": 0}),
    ("可変長 code span の括弧も数えない", "関数 ``fn(`x`, a)`` を呼ぶ。\n", {"paren": 0}),
    ("code span 内の太字は数えない", "`**glob**` は文字列である。\n", {"bold": 0}),
    ("太字は数える", "これは **強調** である。\n", {"bold": 1}),
    ("補足括弧は数える", "これは補足 (理由はこう) を持つ文である。\n", {"paren": 1}),
    ("閉じない括弧は数えない", "壊れた補足 (閉じない。\n", {"paren": 0}),
    ("空行は文の境界になる", "これは段落 1\n\nこれは段落 2\n", {"sentences": 2}),
    ("1. 形式の箇条書きは項目ごとに割れる", "1. 項目 A\n2. 項目 B\n", {"sentences": 2}),
    ("1) 形式の箇条書きも項目ごとに割れる", "1) 項目 A\n2) 項目 B\n", {"sentences": 2}),
    ("nested list も項目ごとに割れる", "- 親\n  - 子 A\n  - 子 B\n", {"sentences": 3}),
    ("tilde fence の中は散文に数えない", "本文である。\n\n~~~sh\necho '(paren)'\n~~~\n", {"paren": 0, "prose_lines": 1}),
    ("backtick fence の中は散文に数えない", "本文である。\n\n```sh\necho '(paren)'\n```\n", {"paren": 0, "prose_lines": 1}),
    (
        "4 backtick fence は 3 backtick で閉じない",
        "本文である。\n\n````md\n```\n中身 (除外)\n```\n````\n",
        {"paren": 0, "prose_lines": 1},
    ),
    (
        "HTML block は散文に数えない",
        '本文である。\n\n<div data-x="fn(a)">\n中身 (除外)\n</div>\n\n次の段落。\n',
        {"paren": 0, "prose_lines": 2, "sentences": 2},
    ),
    (
        "blockquote の空行は文の境界になる",
        "> 引用の段落 1\n>\n> 引用の段落 2\n",
        {"sentences": 2},
    ),
    ("表と ATX 見出しは散文に数えない", "# 見出し\n\n| a | b |\n| --- | --- |\n| 1 | 2 |\n\n本文である。\n", {"prose_lines": 1}),
    ("setext 見出しは本文も下線も散文に数えない", "見出し\n===\n\n本文である。\n", {"prose_lines": 1}),
    ("frontmatter は散文に数えない", "---\nname: x\ndescription: (paren)\n---\n\n本文である。\n", {"prose_lines": 1, "paren": 0}),
    ("HTML comment は散文に数えない", "<!-- (paren) in comment -->\n本文である。\n", {"paren": 0}),
]


def selftest() -> int:
    failed = 0
    for name, src, expect in FIXTURES:
        st = stats(src)
        for key, want in expect.items():
            got = st[key]
            if key == "long":
                got = len(got)
            if got != want:
                failed += 1
                blocks, _ = blocks_of(src)
                print(f"FAIL {name}: {key} = {got}, want {want}")
                print(f"     blocks = {[b.text for b in blocks]}")
    if failed == 0:
        print(f"selftest: {len(FIXTURES)} fixtures OK")
    return 1 if failed else 0


if __name__ == "__main__":
    if "--selftest" in sys.argv:
        sys.exit(selftest())
    verbose = "-v" in sys.argv
    gate = "--gate" in sys.argv
    paths = expand([a for a in sys.argv[1:] if not a.startswith("-")])
    if not paths:
        print(__doc__)
        sys.exit(2)
    results = [measure(p, verbose, gate) for p in paths]
    sys.exit(0 if all(results) else 1)
