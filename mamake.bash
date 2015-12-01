#! /bin/bash

## Constants

declare -A COMMANDS=(\
    ["config"]="config-pkg"\
    ["build"]="build-pkg"\
    ["install"]="install-pkg"\
    ["clean"]="clean-pkg")


## Function Declarations

function usage() {
    echo "usage: $(basename "$0") [command] [build script]"
    echo 'commands:'
    echo -e '\tconfig\t: configure build'
    echo -e '\tbuild\t: start build process'
    echo -e '\tinstall\t: install software'
    echo -e '\tclean\t: cleanup build dir'
    echo -e '\thelp\t: show this message'
    exit
}

function printlog() {
    [ -z "$*" ] || echo "$(basename "$0"): $*" >&2
}

function die() {
    printlog $*
    exit 1
}

function is_func() {
    [ "$( type -t "$1" )" = 'function' ]
}


## Argument Validation

if [[ -z "$1" ]] || [[ "$1" = 'help' ]] || [[ "$1" = '-h' ]]; then
    usage
fi

[[ -z ${COMMANDS[$1]} ]] && die "unknown command '$1'"
[ -z "$2" ] && die 'missing build script'


## Read Build Script

# allow user to omit the .mpk file extension
if [ -f "$2" ]; then
    buildscript="$2"
elif [ -f "${2}.mpk" ]; then
    buildscript="${2}.mpk"
else
    die "cannot find file '$2'"
fi

source "$buildscript"


## Validate Build Script

[ -z "$srcdir" ] && die 'build script does not define $srcdir'
printlog "source dir: $srcdir"

if [ -z "$builddir" ]; then
    printlog '$builddir missing; defaulting to $srcdir'
    builddir=$srcdir
fi
printlog "build dir:  $builddir"
mkdir -pv "$builddir" || exit 1

function="${COMMANDS[$1]}"
is_func "$function" || die "function '$function' missing in build script"


## Execute Build

cd "$builddir"

printlog "executing command '$1'"
${COMMANDS[$1]} || printlog 'command failed'
