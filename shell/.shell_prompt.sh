# palette
black="0"
dark_red="1"
dark_green="2"
dark_yellow="3"
dark_blue="4"
dark_purple="5"
dark_cyan="6"
dark_white="7"
gray="8"
red="9"
green="10"
yellow="11"
blue="12"
purple="13"
cyan="14"
white="15"

# promptline constants

c_wrap="\\033["
end_c_wrap="m"
reset="${c_wrap}0${end_c_wrap}"
reset_bg="${c_wrap}49${end_c_wrap}"
c_fg="38;5;"
c_bg="48;5;"

# promptline functions

# $1: block content
function __promptline_block() {
    local c_block="${c_wrap}${c_fg}${white}${end_c_wrap}"
    local block="${c_block}[${reset}"
    local end_block="${c_block}]${reset}"
    
    echo "${block}$1${end_block}"
}

function __promptline_username {
    local c_username="${c_wrap}${c_fg}${dark_red}${end_c_wrap}"
    local username="${c_username}\u"
    
    echo `__promptline_block $username`
}

function __prompline_hostname {
    local c_hostname="${c_wrap}${c_fg}${dark_red}${end_c_wrap}"
    local hostname="${c_hostname}\h"
    
    echo `__promptline_block $hostname`
}

function __prompline_directory {
    local c_directory="${c_wrap}${c_fg}${dark_cyan}${end_c_wrap}"
    local directory="${c_directory}\w"
    
    echo `__promptline_block $directory`
}

function __promptline_git {
    local c_git="${c_wrap}${c_fg}${cyan}${end_c_wrap}"
    local is_git_tree=`git rev-parse --git-dir > /dev/null 2>&1`
    
    if $is_git_tree; then
        if branch=$( { git symbolic-ref --quiet HEAD || git rev-parse --short HEAD; } 2>/dev/null ); then
            local git="${c_git}${branch##*/}"
            
            echo `__promptline_block $git`
        fi
    fi
}

function __promptline {
    local username=`__promptline_username`
    local hostname=`__prompline_hostname`
    local directory=`__prompline_directory`
    local git=`__promptline_git`
    
    local line1="┌${username}${hostname}${directory}${git}"
    local line2="\n└> "

    PS1="${line1}${line2}"
}

# shelltitle constants

t_wrap="\033]0;"
end_t_wrap="\007"

# shelltitle functions

function __shelltitle {
    echo -ne "${t_wrap}${USER}@${HOSTNAME}: ${PWD}${end_t_wrap}"
}

PROMPT_COMMAND='__promptline;__shelltitle'
