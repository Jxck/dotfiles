---
name: install-creator
description: Create install scripts under ./install/install-<name>.sh following this dotfiles repo's build/install conventions (brew vs self-build, pkg/local layout, OS branching).
---

# install-creator

このドキュメントは、`./install/install-<name>.sh` を
この dotfiles リポジトリの規約に沿って作成するための正本手順です。

## 使う場面

- 新しいツールを dotfiles にビルド可能な形で追加したい
- mac / linux 両対応の install スクリプトを書きたい
- `$DOTFILES/pkg` と `$DOTFILES/local` の規約に従って自前ビルドしたい

## 前提となるディレクトリ規約

- `install/install-<name>.sh` がスクリプト本体
- `$DOTFILES/pkg/<name>`: **ビルドが必要なとき** のソース取得先
- `$DOTFILES/local/<name>`: **ビルド結果の install 先** (`make install` の `--prefix`)
  - ビルド不要 (解凍するだけ / プレビルドバイナリ) の場合は、`pkg` を経由せず `local/<name>` に直接展開する
- ダウンロードは可能な限り `gh release download` を優先する (認証・レート制限が扱いやすいため)
- PATH 追加は **このスクリプトでは絶対にやらない**。`zsh/` 側の個別設定で `addToPath` を呼ぶ
- 再実行時は冒頭で対象ディレクトリを必ず削除してから入れ直す (冪等性を確保する)

## 手順

1. まず判定する (このフローを上から順に試す)

  1. **homebrew にあるか**
     - `brew search <name>` か `brew info <name>` で確認
     - あれば `Brewfile` に追加するだけで済むので、そもそもスクリプトは不要
  2. **mac は brew、linux だけ自前**
     - formula が mac しかない / linux 版が古い
     - → OS 分岐スクリプト (パターン B)
  3. **プレビルドバイナリをそのまま置きたい (ビルド不要)**
     - 配布物が実行可能バイナリ or アーカイブで、展開するだけで使える
     - → 解凍のみパターン (パターン C)
     - `pkg` を経由せず `$DOTFILES/local/<name>` に直接展開する
  4. **完全に自前ビルド**
     - brew formula がない / 特殊なビルドオプションが欲しい
     - → 自前ビルドスクリプト (パターン D)
  5. **公式インストーラがある**
     - `curl ... | bash` のような公式手順が存在する
     - → インストーラ呼び出し (パターン E)

2. ファイル名は `install/install-<name>.sh`

  - `<name>` は導入後のコマンド名に合わせる
  - 例: `install-brotli.sh`, `install-nghttp2.sh`

3. 先頭は `#!/usr/bin/env zsh`

4. 取得方法

  - `gh release download -R <owner>/<name> ...` が使えるなら優先する
  - 次点で `curl -LO https://...`
  - 最後に `git clone --depth 1 ...` (ソースツリーが必要なとき)

5. 冪等性 (必須)

  - 自前ビルドの場合は冒頭で `rm -rf $DOTFILES/pkg/<name>` と `rm -rf $DOTFILES/local/<name>`
  - ビルド不要 (解凍のみ) の場合は `rm -rf $DOTFILES/local/<name>` のみ
  - 再実行すれば古いものを削除してから入れ直す、を前提にする

6. 権限と副作用

  - `sudo apt install` は linux ブランチ内でのみ使う
  - mac 側で `sudo` は使わない (brew が不要な権限昇格を避ける)

7. PATH は通さない (必須)

  - `install-<name>.sh` 内で `export PATH=...` や `addToPath ...` を書かない
  - `.zshrc` や `zsh/*.zsh` 側で個別に `addToPath $DOTFILES/local/<name>/bin` などを追記する
  - このスクリプトの責務は「置く」まで

8. 終わったらテスト

  - `zsh install/install-<name>.sh` で実走
  - `$DOTFILES/local/<name>/bin/<name> --version` 等で確認
  - PATH は別途 `zsh/` 側で対応 (上記 7 参照)

## パターン集

### パターン A: brew のみ

```zsh
#!/usr/bin/env zsh

brew install <name>
```

### パターン B: mac/linux で分岐

linux に brew formula がない / tap が必要な場合:

```zsh
#!/usr/bin/env zsh

if [[ `uname` == "Linux" ]]; then
  brew tap <owner>/<tap> && brew install <name>
elif [[ `uname` == "Darwin" ]]; then
  brew install <name>
fi
```

mac は brew、linux だけ自前ビルドする場合:

```zsh
#!/usr/bin/env zsh

if [[ `uname` == "Darwin" ]]; then
  echo "install via brew"
  exit 0
fi

# linux からの処理を続ける
cd $DOTFILES/pkg
rm -rf $DOTFILES/pkg/<name>
rm -rf $DOTFILES/local/<name>
# ... (パターン C を参照)
```

### パターン C: ビルド不要 (解凍のみ、local に直接展開)

プレビルドバイナリ / アーカイブを落として展開するだけで済む場合。
`pkg` は使わず、`local/<name>` に直接展開する。

```zsh
#!/usr/bin/env zsh

rm -rf $DOTFILES/local/<name>
mkdir -p $DOTFILES/local/<name>
cd $DOTFILES/local/<name>
gh release download -R <owner>/<name> --pattern "*linux-amd64.tar.gz" --output <name>.tar.gz
tar zxvf <name>.tar.gz --strip-components=1
rm <name>.tar.gz
```

- 実行可能バイナリ 1 ファイルだけなら:

```zsh
#!/usr/bin/env zsh

rm -rf $DOTFILES/local/<name>
mkdir -p $DOTFILES/local/<name>/bin
gh release download -R <owner>/<name> --pattern "<name>-linux-amd64" --output $DOTFILES/local/<name>/bin/<name>
chmod +x $DOTFILES/local/<name>/bin/<name>
```

- PATH 追加はこのスクリプトでやらない。後述の通り `zsh/` 側で `addToPath $DOTFILES/local/<name>/bin` する

### パターン D: 自前ビルド

#### D-1: cmake

```zsh
#!/usr/bin/env zsh

cd $DOTFILES/pkg
rm -rf $DOTFILES/pkg/<name>
rm -rf $DOTFILES/local/<name>
gh release download -R <owner>/<name> --archive tar.gz --output <name>.tar.gz
result=`unpack <name>.tar.gz`
version=`echo $result | head -n2 | tail -n1`
mv $version <name>
cd $DOTFILES/pkg/<name>
mkdir $DOTFILES/local/<name>
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$DOTFILES/local/<name>
cmake --build . --config Release --target install
```

#### D-2: autoconf / make

```zsh
#!/usr/bin/env zsh

# linux 依存 (必要なら)
sudo apt install -y \
  autoconf \
  automake \
  libtool  \
  pkg-config

cd $DOTFILES/pkg
DEST=$DOTFILES/pkg/<name>
rm -rf $DEST
rm -rf $DOTFILES/local/<name>
git clone --depth 1 https://github.com/<owner>/<name> $DEST
cd $DEST
autoreconf -i
automake
autoconf
./configure --prefix=$DOTFILES/local/<name>
make
make install
```

#### D-3: tarball (バージョン固定、gh が使えないとき)

```zsh
#!/usr/bin/env zsh

export VERSION=<x.y.z>
cd $DOTFILES/pkg
rm -rf $DOTFILES/pkg/<name>-${VERSION}
rm -rf $DOTFILES/local/<name>
curl -LO https://example.com/<name>-${VERSION}.tar.gz
tar zxvf <name>-${VERSION}.tar.gz
cd <name>-${VERSION}
./configure --prefix=$DOTFILES/local/<name>
make
make install
```

### パターン E: 公式インストーラ

```zsh
#!/usr/bin/env zsh

curl -fsSL https://example.com/install.sh | bash
```

- `curl | bash` は最小限に留める (改ざん検知が弱い)
- 可能なら checksum を追加する

## シェルスクリプトのスタイル

リポジトリ共通規約 (`CLAUDE.md` 参照) に従う:

- インデントはスペース 2 つ
- `if [[` を使う (`[` や `test` は使わない)
- 文字列一致は `==` / `!=` と `*"string"*` の組み合わせ
- 変数有無は `-z` / `-n`
- ファイル有無は `-f` / `-d`
- コマンド有無は `[[ -x "$(command -v foo)" ]]`
- 全角記号を使わない

## 検証チェックリスト

- [ ] shebang が `#!/usr/bin/env zsh`
- [ ] 冒頭で対象ディレクトリを `rm -rf` している (再実行で入れ直せる)
  - ビルドあり: `$DOTFILES/pkg/<name>` と `$DOTFILES/local/<name>` 両方
  - 解凍のみ: `$DOTFILES/local/<name>` のみ
- [ ] ダウンロードは可能なら `gh release download` を使っている
- [ ] ビルドするときは `cd $DOTFILES/pkg` で作業、ビルド結果は `$DOTFILES/local/<name>` に入れる
- [ ] ビルドしないときは `pkg` を使わず `$DOTFILES/local/<name>` に直接展開している
- [ ] `--prefix=$DOTFILES/local/<name>` を渡している (make install する場合)
- [ ] PATH を通すコード (`export PATH=` / `addToPath`) が入っていない
- [ ] linux 側の `sudo apt install` は必要最小限
- [ ] mac 側で `sudo` を使っていない
- [ ] 末尾に改行あり、改行だけの行で終わっていない

## 判断が難しいケース

- **brew にあるが古い**: Brewfile に書きつつ、必要に応じて `install-<name>.sh` で自前版を用意 (両立可)
- **ビルドに大量の依存パッケージが要る**: D-2 のように `apt install` を明示。mac 側は brew が依存を吸収するので触らなくて良い
- **プレビルドバイナリを落とすだけ**: パターン C を使う。`pkg` を経由せず `$DOTFILES/local/<name>` に直接展開する
- **取得元が github release**: `gh release download` を優先 (認証・レート制限が楽)。public で非認証で良いときのみ `curl -LO`
- **PATH 追加はどこでする?**: このスクリプトでは *絶対にやらない*。`zsh/` 側の該当ファイルに `addToPath $DOTFILES/local/<name>/bin` を自分で追加する
