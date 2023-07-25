# FatFs - Generic FAT Filesystem Module

I am _not_ the author of this! It comes from here: http://elm-chan.org/fsw/ff/00index_e.html.

Archives: http://elm-chan.org/fsw/ff/archives.html

This is *not* the official source code. It is at the website above, in zip files.


# References

1. Official FatFs website: http://elm-chan.org/fsw/ff/00index_e.html
    1. Archives (zip files to download): http://elm-chan.org/fsw/ff/archives.html
1. [Unix & Linux: Unzip to a folder with the same name as the file (without the .zip extension)](https://unix.stackexchange.com/a/489449/114401)
1. [My answer on how to use `xargs`](https://unix.stackexchange.com/a/751912/114401)
1. Why we need `bash -c` to get proper substitution: https://stackoverflow.com/a/11158279/4561887


# Notes

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

