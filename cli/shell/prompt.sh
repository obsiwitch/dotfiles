__prompt() {
    # palette
    local black="0"
    local dark_red="1"
    local dark_green="2"
    local dark_yellow="3"
    local dark_blue="4"
    local dark_purple="5"
    local dark_cyan="6"
    local dark_white="7"
    local gray="8"
    local red="9"
    local green="10"
    local yellow="11"
    local blue="12"
    local purple="13"
    local cyan="14"
    local white="15"

    # $1: content
    # $2: color
    prompt.block() {
        local color="\\033[38;5;$2m"
        local reset="\\033[0m"

        echo "[${color}$1${reset}]"
    }

    prompt.git() {
        local is_git_tree=`git rev-parse --git-dir > /dev/null 2>&1`

        if $is_git_tree; then
            if branch=$( { \
                git symbolic-ref --quiet HEAD \
             || git rev-parse --short HEAD; \
            } 2>/dev/null ); then
                echo `prompt.block ${branch##*/} $blue`
            fi
        fi
    }

    prompt.line() {
        local username=`prompt.block "\u" $dark_red`
        local hostname=`prompt.block "\h" $dark_red`
        local directory=`prompt.block "\w" $dark_blue`
        local git=`prompt.git`

        PS1="┌${username}${hostname}${directory}${git}\n└> "
    }

    prompt.title() {
        local t_wrap="\033]0;"
        local end_t_wrap="\007"

        echo -ne "${t_wrap}${USER}@${HOSTNAME}: ${PWD}${end_t_wrap}"
    }

    prompt.line
    prompt.title
}

PROMPT_COMMAND='__prompt'
