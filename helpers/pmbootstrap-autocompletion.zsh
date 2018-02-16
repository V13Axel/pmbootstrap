#!zsh
# Installation: 
#   Copy this file to ~/
#   Insert the following line near the end of your ~/.zshrc:
#
#       source ~/pmbootstrap-auto-completion.zsh
# 
# This file is VERY incomplete, and should really only be trusted to
# autocomplete aports/ directory names.


_pmbootstrap_commands() 
{
    pmbootstrap -h | awk 'c&&!--c;/action:/{c=1}' | sed -e 's/{//g;s/}//g;s/,/ /g'
}

_pmbootstrap_targets()
{
    case $1 in
        menuconfig|checksum|aportgen|build|kconfig_check)
            \ls -1 $PWD/aports/device/
            ;;
        flasher)
            \echo flash_kernel flash_system
            ;;
    esac
}

_pmbootstrap ()
{
	local curcontext="$curcontext" state line
	typeset -A opt_args

    _arguments -C \
        '1: :->command'\
        '2: :->target'
    
    if [ -f $PWD/pmbootstrap.py ]; then #We must be in the pmbootstrap dir
        case $state in
            command)
                compadd `_pmbootstrap_commands`
                ;;
            target)
                compadd `_pmbootstrap_targets $line[1]`
                ;;
        esac
    fi
}

compdef _pmbootstrap pmbootstrap