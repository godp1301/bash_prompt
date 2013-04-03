export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
 
reset='\[\e[00m\]'
bold='\[\e[01m\]'

red='\[\e[0;31m\]'
light_red='\[\e[1;31m\]'
green='\[\e[0;32m\]'
light_green='\[\e[1;32m\]'
yellow='\[\e[1;33m\]'
blue='\[\e[0;34m\]'
light_blue='\[\e[1;34m\]'
purple='\[\e[0;35m\]'
light_purple='\[\e[1;35m\]'
cyan='\[\e[0;36m\]'
light_cyan='\[\e[1;36m\]'
dark_gray='\[\e[1;30m\]'
light_gray='\[\e[0;37m\]'
white='\[\e[1;37m\]'
 
arrow=" → "

user_name_prompt() {
  user="\u"
  echo -n "$light_gray$user"
}

host_name_prompt() {
  host="\h"
  echo -n "$light_gray$host"
}
 
dir_prompt() {
  dir="\W"
  echo -n "$light_red$dir"
}

is_git_dir() {
  is_git_dir=$(git rev-parse --show-toplevel 2>/dev/null) 
  if [ $? -ne 0 ]; then
      echo -n 0
  else
      echo -n 1
  fi
}

git_branch_prompt() {
  git_branch=$(git branch | grep "*" | awk '{print $2}')
  if [ $? -ne 0 ]; then
      echo -n ""
  else
      echo -n "$yellow$arrow$git_branch"  
  fi
}

git_files_changed_prompt(){
  nb_files=$(git status -s | wc -l | tr -d ' ')
  if [ $nb_files -ne 0 ]; then
    echo -n "$yellow : $nb_files"
  else
    echo -n ""
  fi
}

git_ahead_and_behind_prompt(){
  ahead=$(git rev-list @{u}..HEAD 2>/dev/null | wc -l)
  behind=$(git rev-list HEAD..@{u} 2>/dev/null | wc -l)
  if [ $ahead -ne 0 -a $behind -eq 0 ]; then
      ahead_behind="$red +$ahead"
  elif [ $behind -ne 0 -a $ahead -eq 0 ]; then
      ahead_behind="$red -$behind"
  elif [ $ahead -eq 0 -a $behind -eq 0 ]; then
      ahead_behind=""
  else
      ahead_behind="$red +$ahead -$behind"
  fi

  echo -n $ahead_behind
}

prompt() {
  user="$(user_name_prompt)"
  host="$(host_name_prompt)"
  dir="$(dir_prompt)"

  if [ $(is_git_dir) -ne 0 ]; then
      branch=$(git_branch_prompt)
      nb_files=$(git_files_changed_prompt)
      ahead_behind=$(git_ahead_and_behind_prompt)
      PS1="$user@$host:$dir$branch$nb_files$ahead_behind$reset \$ "
  else
      PS1="$user@$host:$dir$reset \$ "
  fi
}
 
unset PS1
PROMPT_COMMAND=prompt
