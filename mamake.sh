#! /bin/bash

### FUNCTIONS

# show help message and exit
function usage() {
    echo "usage: $(basename "$0") [command] [build script]"
    echo 'commands:'
    echo -e '\tconfig\t: configure build'
    echo -e '\tbuild\t: start build process'
    echo -e '\tinst\t: install software'
    echo -e '\thelp\t: show this message'
    exit
}


# log $1 on stderr
function printlog() {
    [ -z "$*" ] || echo "$(basename "$0"): $*" >&2
}


# show error message in $1 and exit
function die() {
    printlog $*
    exit 1
}


# check if $1 is a function
function is_func() {
    # taken from [this SO question](http://stackoverflow.com/questions/85880/determine-if-a-function-exists-in-bash)
    [ "$( type -t "$1" )" = 'function' ]
}


### CHECK ARGUMENTS

# show help on 'help', '-h', or missing command
if [[ -z "$1" ]] || [[ "$1" = 'help' ]] || [[ "$1" = '-h' ]]; then
    usage
fi

# check if command is valid
if [[ "$1" != 'config' ]] && [[ "$1" != 'build' ]] && [[ "$1" != 'inst' ]]; then
    die "unknown command '$1'"
fi

# check if second arg is present
[ -z "$2" ] && die 'missing build'


### LOAD BUILD SCRIPT

# allow user to omit the .mpk file extension
if [ -f "$2" ]; then
    buildscript="$2"
elif [ -f "${2}.mpk" ]; then
    buildscript="${2}.mpk"
else
    die "cannot find file '$2'"
fi


# source build script
source "$buildscript"

# check if source dir was given
[ -z "$srcdir" ] && die 'build script does not define $srcdir'
printlog "source dir: $srcdir"

# config build directory (if none, default to source dir)
if [ -z "$builddir" ]; then
    printlog '$builddir missing; defaulting to $srcdir'
    builddir=$srcdir
fi
printlog "build dir:  $builddir"
# create build dir if necessary
mkdir -pv "$builddir" || exit 1

# check if the requested command is actually implemented
is_func "$1" || die "function '$1' missing in build script"


### START ACTUAL COMMAND

# go to build dir
cd "$builddir"

# execute command
case "$1" in
    'config')
        printlog 'configuring...'
        config || printlog 'configuration failed'
        ;;
    'build')
        printlog 'building...'
        build || printlog 'build failed'
        ;;
    'inst')
        printlog 'installing...'
        inst || printlog 'installation failed'
        ;;
esac
