#! /bin/zsh

export LANG="en_US.utf8"
export LANGUAGE="en_US.utf8"
export LC_ALL="en_US.utf8"

export PATH=./bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:${HOME}/.gem/bin

# Add custom completions and prompt to fpath
fpath=(~/.zsh.d/custom_funcs $fpath)

# Set GEM_HOME to allow user installation of gems
export GEM_HOME=~/.gem

# Load zshuery
source ${HOME}/.zshuery/zshuery.sh
load_defaults
load_aliases
load_completion ${HOME}/.zshuery/completion

setopt extended_glob

# Configure colors
if [[ -x dircolors ]]; then
  eval "`dircolors ~/.zsh.d/dircolors`"
  export ZLS_COLORS=$LS_COLORS
fi

# Setup editor
export EDITOR='vim'

# Use another histfile
[ -w $zsh_cache ] && HISTFILE=$zsh_cache/history

# Set options
setopt path_dirs
setopt auto_pushd               # make cd push the dir to a stack
setopt long_list_jobs
autoload -U is-at-least
is-at-least 4.3.0 && {
  unsetopt hist_save_by_copy
}

LISTMAX=1000                # never ask
NULLCMD='cat'               # use cat for > null commands
REPORTTIME=2                # report time if execution exceeds amount of seconds
LOGCHECK=60
watch=(notme)               # watch login/logout
DIRSTACKSIZE=10             # Max. size of the stack befor it gets truncated

## Setup the default pager
export PAGER=less
export LESS="-X"

# http://xanana.ucsc.edu/~wgscott/wordpress_new/wordpress/?p=12
typeset -ga preexec_functions
typeset -ga precmd_functions
typeset -ga chpwd_functions

autoload -U select-word-style
select-word-style bash

projects_dir="/var/fejo-dk"

# Which plugins should be loaded
plugins=(zsh-syntax-highlighting zsh-history-substring-search)

# load specific configurations
for zshrc_snipplet in ~/.zsh.d/C[0-9][0-9]*[^~] ; do
  source $zshrc_snipplet
done
