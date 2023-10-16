#!/usr/bin/env bash

# See: https://stackoverflow.com/a/60157372/4561887
FULL_PATH_TO_SCRIPT="$(realpath "${BASH_SOURCE[-1]}")"
SCRIPT_DIRECTORY="$(dirname "$FULL_PATH_TO_SCRIPT")"

# -----------------------------------------------------------
# 1. Install dependencies, such as wine
# -----------------------------------------------------------
echo "Installing dependencies."

sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt install -y \
    wine

echo ""
echo "==========="

# -----------------------------------------------------------
# 2. Install mkfatimg.exe as a bash script wrapper into ~/bin
# -----------------------------------------------------------

PATH_TO_MKFATIMG="$SCRIPT_DIRECTORY/documents/res/mkfatimg/Release/mkfatimg.exe"
echo "Making a bash script wrapper for mkfatimg.exe at: path \"$PATH_TO_MKFATIMG\"."
mkdir -p ~/bin

# heredoc storing an entire file
# - NB: using any quotes around the heredoc delimiter, as in `'END_OF_FILE'` or `"END_OF_FILE"` in
#   this case, will cause it NOT to contain variable expansion. So, we leave off all quotes, as in
#   `END_OF_FILE` in this case, to cause `$PATH_TO_MKFATIMG`, for instance, to expand within the
#   heredoc.
#   - See:
#       - https://stackoverflow.com/a/4938197/4561887
#       - https://stackoverflow.com/questions/4937792/using-variables-inside-a-bash-heredoc#comment42316093_4937792
executable_contents=$(cat <<END_OF_FILE > ~/bin/mkfatimg.exe
#!/usr/bin/env bash

wine "$PATH_TO_MKFATIMG" "\$@"
END_OF_FILE
)

# Make it executable
chmod +x ~/bin/mkfatimg.exe

# -----------------------------------------------------------
# 3. Add ~/bin to the PATH only if it is NOT already in it,
#    and re-source to bring in the change.
# -----------------------------------------------------------

text_to_add_to_bottom_of_bashrc=$(cat <<'END_OF_FILE'
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi
END_OF_FILE
)

# Check if the folder is already in the PATH
# See: https://stackoverflow.com/a/1397020/4561887
if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
    # Add it to the PATH
    echo "Adding ~/bin to the PATH via ~/.bashrc"
    echo -e "\n$text_to_add_to_bottom_of_bashrc" >> ~/.bashrc

    # Re-source, to bring in this change to the current terminal

    if [[ -f "$HOME/.profile" ]]; then
        echo "Re-sourcing ~/.profile"
        . ~/.profile
    fi

    echo "Re-sourcing ~/.bashrc"
    . ~/.bashrc
fi

echo "Done."
