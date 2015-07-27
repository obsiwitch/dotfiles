# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/Bin" ] ; then
    PATH="$HOME/Bin:$PATH"
fi
