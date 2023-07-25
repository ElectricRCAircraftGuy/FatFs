# FatFs - Generic FAT Filesystem Module

I am _not_ the author of this! It comes from here: http://elm-chan.org/fsw/ff/00index_e.html.

Archives: http://elm-chan.org/fsw/ff/archives.html

This is *not* the official source code. It is at the website above, in zip files.


# Current revision in the repo root:

[`Nov 06, 2022    FatFs R0.15 (latest release)`](http://elm-chan.org/fsw/ff/archives.html)


# References

1. Official FatFs website: http://elm-chan.org/fsw/ff/00index_e.html
    1. Archives (zip files to download): http://elm-chan.org/fsw/ff/archives.html
1. [Unix & Linux: Unzip to a folder with the same name as the file (without the .zip extension)](https://unix.stackexchange.com/a/489449/114401)
1. [My answer on how to use `xargs`](https://unix.stackexchange.com/a/751912/114401)
1. Why we need `bash -c` to get proper substitution: https://stackoverflow.com/a/11158279/4561887


# TODO

1. [ ] Get `mkfatimg` to build natively on Linux so that I don't have to use Wine to run it on Linux.


# Notes

1. I put a bunch of the archived versions (the most recent 17 versions or so) into the [Archives](Archives) dir, and extracted them using my commands below.
1. The repo root contains only the most-recently-released version--ex: the contents of [Archives/ff15](Archives/ff15).

1. Zip file extraction notes:

    ```bash
    # Install `unar`
    sudo apt update
    sudo apt install unar

    # Extract all of the archive .zip files
    # See:
    # 1. https://unix.stackexchange.com/a/489449/114401
    # 1. My answer: https://unix.stackexchange.com/a/751912/114401
    cd Archives

    time find . -maxdepth 1 -type f -iname "*.zip" -print0 \
        | xargs -0 -I{} -n 1 -P $(nproc) unar -f "{}"

    # Extract all embedded .zip files, including all "documents/res/mkfatimg.zip"
    # `mkfatimg.exe` program files which are located in the extracted dirs from
    # above.
    # See: 
    # 1. Why we need `bash -c` to get proper substitution:
    # https://stackoverflow.com/a/11158279/4561887
    cd Archives

    time find . -mindepth 2 -type f -iname "*.zip" -print0 \
        | xargs -0 -I{} -n 1 -P $(nproc) bash -c 'unar -f "{}" -o "$(dirname "{}")"'

    # Check the `sha256sum`s of all .exe files now
    find . -iname "*.exe" | xargs -I{} -n 1 sha256sum {}
    # Example run and output:
    #
    #       FatFs/Archives$ find . -iname "*.exe" | xargs -I{} -n 1 sha256sum {}
    #       a589b6ae6b6e9001b0d7f8a966494822a1ea1b096ff5df33908fc4d7acaae316  ./ff14a/documents/res/mkfatimg/Release/mkfatimg.exe
    #       a589b6ae6b6e9001b0d7f8a966494822a1ea1b096ff5df33908fc4d7acaae316  ./ff14b/documents/res/mkfatimg/Release/mkfatimg.exe
    #       a589b6ae6b6e9001b0d7f8a966494822a1ea1b096ff5df33908fc4d7acaae316  ./ff13c/documents/res/mkfatimg/Release/mkfatimg.exe
    #       a589b6ae6b6e9001b0d7f8a966494822a1ea1b096ff5df33908fc4d7acaae316  ./ff14/documents/res/mkfatimg/Release/mkfatimg.exe
    #       a589b6ae6b6e9001b0d7f8a966494822a1ea1b096ff5df33908fc4d7acaae316  ./ff15/documents/res/mkfatimg/Release/mkfatimg.exe
    #
    ```

    It looks like they haven't rebuilt the .exe executable included there in the "Release" dir, as they are all the same. :(

1. Use `meld` to compare dirs:
    ```bash
    sudo apt install meld

    # Example
    meld Archives/ff14b Archives/ff15
    ```
    Double-click on filenames in blue in the GUI meld viewer that opens up to see how those files have changed.

1. `mkfatimg.exe` (ex: located here: [documents/res/mkfatimg/Release/mkfatimg.exe](documents/res/mkfatimg/Release/mkfatimg.exe)) is a Windows executable. You can run it in Linux with Wine as follows:
    ```bash
    # install wine
    sudo apt update 
    sudo apt install wine

    # use it
    wine path/to/mkfatimg.exe
    # Ex:
    wine documents/res/mkfatimg/Release/mkfatimg.exe
    ```

    To make it runnable on Linux as `mkfatimg.exe` directly, which is useful so your build system can run it on either Windows *or* Linux, for instance, with*out* changing the command in your makefile which calls it, do the following:

    ```bash
    mkdir -p ~/bin
    . ~/.profile  # this adds ~/bin to your PATH, on a default Ubuntu install

    # create and edit this new file
    gedit ~/bin/mkfatimg.exe
    ```
    Now paste the following into it (updating the path as necessary):
    ```bash
    #!/usr/bin/env bash

    wine "path/to/mkfatimg.exe" "$@"
    ```
    Then make it executable:
    ```bash
    chmod +x ~/bin/mkfatimg.exe
    ```

    Now it is runnable directly like this on Linux!:
    ```bash
    mkfatimg.exe
    ```

