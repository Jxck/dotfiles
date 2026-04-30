#!/usr/bin/env zsh

# wire agent skills from $DOTFILES/.agents/skills into ~/.claude and ~/.codex
#
# claude:  ~/.claude/skills -> $DOTFILES/.claude/skills (-> ../.agents/skills)
# codex:   ~/.codex/skills/<name> -> $DOTFILES/.agents/skills/<name>
#          (codex's bundled .system/ lives alongside, so we link per-skill)

# claude
mkdir -p ~/.claude
claude_link=~/.claude/skills
claude_target=$DOTFILES/.claude/skills
if [[ -e $claude_link && ! -L $claude_link ]]; then
  echo "skip $claude_link (not a symlink)"
else
  ln -sfn $claude_target $claude_link
fi

# codex
mkdir -p ~/.codex/skills
for skill_dir in $DOTFILES/.agents/skills/*(/N); do
  link=~/.codex/skills/${skill_dir:t}
  if [[ -e $link && ! -L $link ]]; then
    echo "skip $link (not a symlink)"
    continue
  fi
  ln -sfn $skill_dir $link
done
