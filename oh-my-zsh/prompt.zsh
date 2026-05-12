# Override oh-my-zsh's git_prompt_info to color the branch name based on
# working-tree state: green when clean, red when dirty. Keeps the rest of
# the robbyrussell theme intact (the "git:(" wrapper, ")" suffix, and the
# yellow ✗ dirty marker all still come from ZSH_THEME_GIT_PROMPT_*).
function git_prompt_info() {
  local ref
  if [[ "$(__git_prompt_git config --get oh-my-zsh.hide-status 2>/dev/null)" == "1" ]]; then
    return 0
  fi
  ref=$(__git_prompt_git symbolic-ref HEAD 2> /dev/null) \
    || ref=$(__git_prompt_git rev-parse --short HEAD 2> /dev/null) \
    || return 0

  local dirty branch_color
  dirty=$(parse_git_dirty)
  if [[ -n "$dirty" ]]; then
    branch_color="%{$fg[red]%}"
  else
    branch_color="%{$fg[green]%}"
  fi

  echo "${ZSH_THEME_GIT_PROMPT_PREFIX}${branch_color}${ref#refs/heads/}${dirty}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}
