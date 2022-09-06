function git_branch() {
  git_branch=$(git branch --no-color 2>/dev/null | grep \* | sed 's/* //')

  if [ $git_branch ]
  then
    white="\001\033[0;37m\002"
    yellow="\001\033[0;33m\002"
    blue="\001\033[0;34m\002"
    red="\001\033[0;31m\002"

    git_status=$(git status --porcelain 2>/dev/null)
    git_count_t=$(for i in "$git_status"; do echo "$i"; done | grep -v '^?? ' | sed '/^$/d' | wc -l | sed "s/ //g")
    git_count_color_t=$(if [ $git_count_t = "0" ]; then echo -e "$blue"; else echo -e "$red"; fi)
    git_count_ut=$(for i in "$git_status"; do echo "$i"; done | grep '^?? ' | sed '/^$/d' | wc -l | sed "s/ //g")
    git_count_color_ut=$(if [ $git_count_ut = "0" ]; then echo -e "$blue"; else echo -e "$red"; fi)

    echo -e "$white:$yellow${git_branch}$white:$git_count_color_t${git_count_t}$white:$git_count_color_ut${git_count_ut}"
  fi
}

short_pwd() {
  cwd=$(pwd | sed "s#${HOME}#~#g" | perl -F/ -ane 'print join( "/", map { $i++ < @F - 1 ?  substr $_,0,1 : $_ } @F)')
  echo -n $cwd
}

set_bash_prompt() {
  if [ "$UID" = 0 ]; then
    #root
    PS1="\[\033[0;31m\]\u\[\033[0;37m\]@\h\[\033[1;37m\] \[\033[0;31m\]\$(short_pwd)\$(git_branch)\[\033[0;36m\]# \[\033[0m\]"
  else
    #non-root
    PS1="\[\033[0;32m\]\u\[\033[0;37m\]@\h\[\033[1;37m\] \[\033[0;32m\]\$(short_pwd)\$(git_branch)\[\033[0;36m\]$ \[\033[0m\]"
  fi
}

set_bash_prompt
