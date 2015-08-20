[ "$TERM" == "xterm-256color" ] && SCREENDIR=~/.screen screen -DD -R
alias screen="SCREENDIR=~/.screen screen -DD -R"
export PATH=$PATH:/home/kmcfate/.gem/ruby/1.9.1/bin/:$HOME/bin
prompt_command() {
    RET=$?
    history -a
    history -c
    history -r
#    if [ "$TERM" == "screen" ]; then echo -ne "\033k$(hostname -s)\033\\"; fi

    local XTERM_TITLE='\[\e]2;\]\u@\H:\w\a'

    local BGJOBS_COLOR='\[\e[1;30m\]'
    local BGJOBS=""
    if [ "$(jobs | head -c1)" ]; then BGJOBS=" $BGJOBS_COLOR(bg:\j)"; fi

    local DOLLAR_COLOR='\[\e[1;32m\]'
    if [[ ${RET} != 0 ]] ; then DOLLAR_COLOR="\[\e[1;31m\]"; fi
    local DOLLAR='$DOLLAR_COLOR$'

    local USER_COLOR='\[\e[1;32m\]'
    if [[ ${EUID} == 0 ]]; then USER_COLOR='\[\e[1;31m\]'; fi

    #tput smkx
    PS1="$XTERM_TITLE$USER_COLOR\u\[\e[1;30m\]@\[\e[1;34m\]\H\[\e[1;30m\]:\[\e[m\]\[\e[0;37m\]\w\[\e[m\]\n$DOLLAR$BGJOBS \[\e[m\]"
}

    export HISTCONTROL=ignoreboth
    export HISTTIMEFORMAT="[%Y/%m/%d %H:%M:%S] "
    export HISTFILE=$HOME/.history/`hostname |cut -d '.' -f 1-3 || echo unknown`
    export HISTSIZE=1000000
    export HISTFILESIZE=100000000
    # append to the history file, don't overwrite it
    shopt -s histappend
    export PROMPT_COMMAND=prompt_command

bgxupdate() {
    bgxoldgrp=${bgxgrp}
    bgxgrp=""
    ((bgxcount = 0))
    bgxjobs=" $(jobs -pr | tr '\n' ' ')"
    for bgxpid in ${bgxoldgrp} ; do
        echo "${bgxjobs}" | grep " ${bgxpid} " >/dev/null 2>&1
        if [[ $? -eq 0 ]] ; then
            bgxgrp="${bgxgrp} ${bgxpid}"
            ((bgxcount = bgxcount + 1))
        fi
    done
}

bgxlimit() {
    bgxmax=$1 ; shift
    bgxupdate
    while [[ ${bgxcount} -ge ${bgxmax} ]] ; do
        sleep 1
        bgxupdate
    done
    if [[ "$1" != "-" ]] ; then
        $* &
        bgxgrp="${bgxgrp} $!"
    fi
}

sslvalidate() {
    (
    openssl x509 -in $1.crt -noout -modulus|openssl md5;
    openssl req -in $1.csr -noout -modulus|openssl md5;
    openssl rsa -in $1.key -noout -modulus|openssl md5;
    )|sort|uniq
}
