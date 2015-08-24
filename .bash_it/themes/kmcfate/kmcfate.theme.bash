#!/usr/bin/env bash 

# Theme inspired on:
#  - Ronacher's dotfiles (mitsuhikos) - http://github.com/mitsuhiko/dotfiles/tree/master/bash/
#  - Glenbot - http://theglenbot.com/custom-bash-shell-for-development/
#  - My extravagant zsh - http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/
#  - Monokai colors - http://monokai.nl/blog/2006/07/15/textmate-color-theme/
#  - Bash_it modern theme
#
# Screenshot: http://goo.gl/VCmX5
# by Jesus de Mula <jesus@demula.name>

# For the real Monokai colors you should add these to your .XDefaults or 
# terminal configuration:
#! ----------------------------------------------------------- TERMINAL COLORS
#! monokai - http://www.monokai.nl/blog/2006/07/15/textmate-color-theme/
#*background: #272822
#*foreground: #E2DA6E
#*color0: black
#! mild red
#*color1: #CD0000
#! light green
#*color2: #A5E02D
#! orange (yellow)
#*color3: #FB951F
#! "dark" blue
#*color4: #076BCC
#! hot pink
#*color5: #F6266C
#! cyan
#*color6: #64D9ED
#! gray
#*color7: #E5E5E5

base03=${bold_black}
base02=${black}
base01=${bold_green}
base00=${bold_yellow}
base0=${bold_blue}
base1=${bold_cyan}
base2=${white}
base3=${bold_white}
orange=${bold_red}
violet=${bold_purple}

# ----------------------------------------------------------------- COLOR CONF
D_DEFAULT_COLOR="${normal}"
D_INTERMEDIATE_COLOR="${base01}"
D_USER_COLOR="${green}"
D_SUPERUSER_COLOR="${red}"
D_MACHINE_COLOR="${violet}"
D_DIR_COLOR="${normal}"
D_SCM_COLOR="${yellow}"
D_BRANCH_COLOR="${yellow}"
D_CHANGES_COLOR="${white}"
D_CMDFAIL_COLOR="${red}"
D_VIMSHELL_COLOR="${cyan}"
D_BGJOBS_COLOR="${magenta}"

# ------------------------------------------------------------------ FUNCTIONS
case $TERM in
  xterm*)
      TITLEBAR="\033]0;\w\007"
      ;;
  screen*)
      unset TITLEBAR
      echo -ne "\ek$(hostname -s)\e\\"
      ;;
  *)
      TITLEBAR=""
      ;;
esac

is_vim_shell() {
  if [ ! -z "$VIMRUNTIME" ];
  then
    echo "${D_INTERMEDIATE_COLOR}on ${D_VIMSHELL_COLOR}\
vim shell${D_DEFAULT_COLOR} "
  fi
}

mitsuhikos_lastcommandfailed() {
  code=$?
  if [ $code != 0 ];
  then
    echo "${D_INTERMEDIATE_COLOR}exited ${D_CMDFAIL_COLOR}\
$code ${D_DEFAULT_COLOR}" 
  fi
}

# vcprompt for scm instead of bash_it default
demula_vcprompt() {
  if [ ! -z "$VCPROMPT_EXECUTABLE" ];
  then
    local D_VCPROMPT_FORMAT="on ${D_SCM_COLOR}%s${D_INTERMEDIATE_COLOR}:\
${D_BRANCH_COLOR}%b %r ${D_CHANGES_COLOR}%m%u ${D_DEFAULT_COLOR}"
    $VCPROMPT_EXECUTABLE -f "$D_VCPROMPT_FORMAT"	
  fi
}

# checks if the plugin is installed before calling battery_charge
safe_battery_charge() {
  if [ -e "${BASH_IT}/plugins/enabled/battery.plugin.bash" ];
  then
    battery_charge
  fi
}

# -------------------------------------------------------------- PROMPT OUTPUT
prompt() {
  local LAST_COMMAND_FAILED=$(mitsuhikos_lastcommandfailed)
  local SAVE_CURSOR='\033[s'
  local RESTORE_CURSOR='\033[u'
  local MOVE_CURSOR_RIGHTMOST='\033[500C'
  local MOVE_CURSOR_5_LEFT='\033[5D'
#  local D_USER_COLOR="\[\e[1;32m\]"
#  if [[ ${EUID} == 0 ]]; then D_USER_COLOR="\[\e[1;31m\]"; fi
#  local DOLLAR_COLOR="\[\e[1;32m\]"
#  if [[ ${RET} != 0 ]] ; then DOLLAR_COLOR="\[\e[1;31m\]"; fi
#  local DOLLAR="$DOLLAR_COLOR\\\$"



  if [ $(uname) = "Linux" ];
  then
    PS1="${TITLEBAR}\
${SAVE_CURSOR}${MOVE_CURSOR_RIGHTMOST}${MOVE_CURSOR_5_LEFT}\
$(safe_battery_charge)${RESTORE_CURSOR}\
${D_USER_COLOR}\u${D_INTERMEDIATE_COLOR}\
@${D_MACHINE_COLOR}\h${D_INTERMEDIATE_COLOR}\
:${D_DIR_COLOR}\w ${D_INTERMEDIATE_COLOR}\
${LAST_COMMAND_FAILED}\
$(demula_vcprompt)\
$(is_vim_shell)
${D_INTERMEDIATE_COLOR}$ ${D_DEFAULT_COLOR}"
  else
    PS1="${TITLEBAR}\
${D_USER_COLOR}\u${D_INTERMEDIATE_COLOR}\
@${D_MACHINE_COLOR}\h${D_INTERMEDIATE_COLOR}\
:${D_DIR_COLOR}\w ${D_INTERMEDIATE_COLOR}\
${LAST_COMMAND_FAILED}\
$(demula_vcprompt)\
$(is_vim_shell)\
$(safe_battery_charge)
${D_INTERMEDIATE_COLOR}$ ${D_DEFAULT_COLOR}"
  fi

  PS2="${D_INTERMEDIATE_COLOR}$ ${D_DEFAULT_COLOR}"
}

# Runs prompt (this bypasses bash_it $PROMPT setting)
PROMPT_COMMAND=prompt

