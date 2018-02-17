#!zsh
#	Installation: 
#
#	Copy this file to ~/.zsh/ (create it, if it doesn't exist, or put it 
#	somewhere that makes sense to you) Then, insert the following line 
#	in your ~/.zshrc (making sure to use the right folder name, if changed):
#
#		source ~/.zsh/pmbootstrap-auto-completion.zsh
#
#	Then, set the variable PMBOOTSTRAP_DIR to your `pmbootstrap` root.
#	Example:
#
#		PMBOOTSTRAP_DIR=/home/axel/Git/pmbootstrap
#	
#	This file is VERY incomplete, and should really only be trusted to
#	autocomplete directory names at this time.

PMBOOTSTRAP_DIR=

_pmbootstrap_commands () 
{
	grep '^def ' $PMBOOTSTRAP_DIR/pmb/helpers/frontend.py | cut -d ' ' -f 2 | cut -d '(' -f 1 | grep -v '^_'
}

_pmbootstrap_targets ()
{
	case $1 in
		checksum|aportgen|build)
			find $PMBOOTSTRAP_DIR/aports/ -mindepth 2 -type d -printf  '%f\n' | sed "s|$PMBOOTSTRAP_DIR/aports/||g"
			;;
		kconfig_check)
			ls -1 $PMBOOTSTRAP_DIR/aports/device/
			;;
		menuconfig)
			ls -1 $PMBOOTSTRAP_DIR/aports/device/ | grep linux- | sed 's/linux-//g'
			;;
		flasher)
			echo flash_kernel flash_system
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
		
		case $state in
			command)
				compadd `_pmbootstrap_commands`
				;;
			target)
				compadd `_pmbootstrap_targets $line[1]`
				;;
		esac
}

if [ -d "$PMBOOTSTRAP_DIR" ] && [ -f $PMBOOTSTRAP_DIR/pmbootstrap.py ]; then
	compdef _pmbootstrap pmbootstrap
fi