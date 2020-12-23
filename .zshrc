# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# Initialize completion
# autoload -U compinit
# compinit -D

# Add paths
export PATH=/usr/local/sbin:/usr/local/bin:${PATH}
export PATH="$HOME/bin:$PATH"
export PATH="./node_modules/.bin:$PATH"

# Colorize terminal
alias ls='ls -G'
alias ll='ls -lG'
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"


# GITHUB_TOKEN
# Add personal token when needed


# Nicer history
export HISTSIZE=100000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE

# Stop wget from creating ~/.wget-hsts file. I don't care about HSTS (HTTP
# Strict Transport Security) for wget; it's not as if I'm logging into my bank
# with it.
alias wget='wget --no-hsts'

# Use vim as the editor
export EDITOR=vi
# GNU Screen sets -o vi if EDITOR=vi, so we have to force it back.
set -o emacs

# Use C-x C-e to edit the current command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# By default, zsh considers many characters part of a word (e.g., _ and -).
# Narrow that down to allow easier skipping through words via M-f and M-b.
export WORDCHARS='*?[]~&;!$%^<>'

# Highlight search results in ack.
export ACK_COLOR_MATCH='red'

# Aliases
function mkcd() { mkdir -p $1 && cd $1 }
function cdf() { cd *$1*/ } # stolen from @topfunky
alias zshconfig="vi ~/.zshrc"
alias ohmyzsh="vi ~/.oh-my-zsh"
alias sl="ls"

# fd alias for linux distributions https://github.com/sharkdp/fd#on-debian
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    alias fd='fdfind'
fi

# Activate the closest virtualenv by looking in parent directories.
activate_virtualenv() {
    if [ -f env/bin/activate ]; then . env/bin/activate;
    elif [ -f ../env/bin/activate ]; then . ../env/bin/activate;
    elif [ -f ../../env/bin/activate ]; then . ../../env/bin/activate;
    elif [ -f ../../../env/bin/activate ]; then . ../../../env/bin/activate;
    fi
}

# Find the directory of the named Python module.
python_module_dir () {
    echo "$(python -c "import os.path as _, ${1}; \
        print _.dirname(_.realpath(${1}.__file__[:-1]))"
        )"
}

# By @ieure; copied from https://gist.github.com/1474072
#
# It finds a file, looking up through parent directories until it finds one.
# Use it like this:
#
#   $ ls .tmux.conf
#   ls: .tmux.conf: No such file or directory

#   $ ls `up .tmux.conf`
#   $HOME/.tmux.conf

#   $ cat `up .tmux.conf`
#   set -g default-terminal "screen-256color"
#
function up()
{
    local DIR=$PWD
    local TARGET=$1
    while [ ! -e $DIR/$TARGET -a $DIR != "/" ]; do
        DIR=$(dirname $DIR)
    done
    test $DIR != "/" && echo $DIR/$TARGET
}

# Switch projects
function p() {
    local proj
    proj=$(ls ~/proj | selecta)
    if [[ -n "$proj" ]]; then
        cd ~/proj/$proj
        if [[ -e "Gemfile" ]]; then
            local ruby_version
            ruby_version=$(ruby -ne $'print $1 if $_ =~ /ruby [\'"]([0-9.]+)[\'"]/' Gemfile)
            chruby "$ruby_version"
            gem_home .
        fi
        if [[ -d ~/secrets/$proj ]]; then
            . ~/secrets/$proj/secrets.sh
        fi
    fi
}

# Edit a note
function note() {
    local note=$(find ~/notes/* | selecta)
    if [[ -n "$note" ]]; then
        (cd ~/notes && vi "$note")
    fi
}

# By default, ^S freezes terminal output and ^Q resumes it. Disable that so
# that those keys can be used for other things.
unsetopt flowcontrol
# Run Selecta in the current working directory, appending the selected path, if
# any, to the current command.
function insert-selecta-path-in-command-line() {
    local selected_path
    # Print a newline or we'll clobber the old prompt.
    echo
    # Find the path; abort if the user doesn't select anything.
    selected_path=$(fd -t f . | selecta) || return
    # Escape the selected path, since we're inserting it into a command line.
    # E.g., spaces would cause it to be multiple arguments instead of a single
    # path argument.
    selected_path=$(printf '%q' "$selected_path")
    # Append the selection to the current command buffer.
    eval 'LBUFFER="$LBUFFER$selected_path "'
    # Redraw the prompt since Selecta has drawn several new lines of text.
    zle reset-prompt
}
# Create the zle widget
zle -N insert-selecta-path-in-command-line
# Bind the key to the newly created widget
bindkey "^S" "insert-selecta-path-in-command-line"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="simple"

# nvm
export PATH="$HOME/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
export PATH="$HOME/.yarn/bin:$PATH"
export TERM="xterm"

# oh-my-zsh
plugins=(git zsh-autosuggestions zsh-autocomplete tmux)
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh
