if [[ ${EUID} != 0 ]]; then
    export HISTCONTROL=ignoredups
    export HISTTIMEFORMAT="[%Y/%m/%d %H:%M:%S] "
    export HISTFILE=$HOME/.history/$(hostname |cut -d '.' -f 1-3 || echo unknown)
    export HISTSIZE=1000000
    export HISTFILESIZE=100000000
    # append to the history file, don't overwrite it
    shopt -s histappend
fi

PROMPT_COMMAND="${PROMPT_COMMAND};history -a;history -c;history -r"
