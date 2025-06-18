#!/bin/zsh

local file
local -a exclude_dirs
local exclude_args=""

exclude_dirs=(
  .git
  public
  node_modules
  .config/tmux/plugins
  .ssh
  .npm
  .cache
  .local
)

for dir in $exclude_dirs; do
  exclude_args+=" --exclude $dir"
done

local current_pane_id=$(tmux display -p '#{pane_id}')

file=$(eval "fd --type f --hidden $exclude_args" | fzf --tmux bottom,50,18 --style full) || exit 0

if [ -n "$file" ]; then
  tmux send-keys -t "$current_pane_id" "nvim \"$HOME/$file\"" C-m
fi
