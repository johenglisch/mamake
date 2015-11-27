mamake - Manual Make
====================

## Description ##

`mamake` builds software packages from source and installs them by executing
a build script provided by the user.

This tools just unifies manual software installations and does not aim to
replace full-fledged package managers like apt or pacman.  I basically just
wrote this because I could not be bothered remembering which software uses which
build system (cmake, autotools etc.) or which options I fed into `./configure`
this time...

## Installation ##

Just copy `mamake.bash` somewhere into your `$PATH`.  You might also want to
remove that ugly file extension, e.g.:

    # install mamake.bash /usr/local/bin/mamake

## Requirements ##

 * bash 4

## Usage ##

Create a build script as a plain text file pass it to mamake as an command-line
argument:

    mamake [command] [build script]
    commands:
        config  : configure build
        build   : start build process
        inst    : install software
        clean   : cleanup build dir
        help    : show this message

For the contents of the build script, see the annotated example script
`example.mpk`.

## License ##

See `LICENSE` file.
