# =============================================================================
#  1. Environment & PATH
#  This should come first so the shell can find all commands.
# =============================================================================
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH" #bun path
export ZSH="$HOME/.oh-my-zsh"
export TERMINAL=kitty
export EDITOR="/usr/bin/nvim"
export VISUAL="/usr/bin/nvim"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_THEME=""
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

cat ~/.cache/wal/sequences

# Function to set pywal theme and run sequences script
waltheme() {
    if [ -z "$1" ]; then
        echo "Usage: waltheme /path/to/image.jpg"
        return 1
    fi
    wal -i "$1" -o "$HOME/.config/wal/sequences"
}

# bun completions
[ -s "/home/killionaire/.bun/_bun" ] && source "/home/killionaire/.bun/_bun"

eval "$(starship init zsh)"

# ~/.zshrc
alias t='tmux attach || tmux new-session' # Attach to existing session or create a new one
# ~/.dotfiles bare git repo
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
# course directory alias
alias cs50="cd /home/killionaire/Documents/Notes/cs50webprogramming"

# --- fzf for directory navigation (without zoxide) ---

# Common fzf options for directory selection
_fzf_dir_options=(
  --height 40% --layout=reverse --border
  --preview 'ls -F {}' # Shows contents of selected directory
  --bind "ctrl-o:execute(xdg-open {} > /dev/null 2>&1)" # Open selected dir in file manager
  --bind "ctrl-e:execute(nvim {} > /dev/null 2>&1)" # Open selected dir in Neovim

  # --- Vim-like Keybindings (using Ctrl combinations to avoid search conflicts) ---
  --bind "ctrl-j:down"    # Ctrl+J for down
  --bind "ctrl-k:up"      # Ctrl+K for up
  --bind "ctrl-d:half-page-down" # Ctrl+D for half page down
  --bind "ctrl-u:half-page-up"   # Ctrl+U for half page up
  # Removed: plain 'j' and 'k' to avoid conflict with typing search query
  # Removed: 'gg' and 'G' as they are unsupported multi-character binds in older fzf
  # --- End Vim-like Keybindings ---
)

# Function to jump to a directory using fzf
function zf() {
  local selected_dir

  selected_dir=$( (
    # 1. Directories from your shell's pushd/popd stack (if active)
    dirs -l -p 2>/dev/null

    # 2. Unique directories from your shell history (grep for 'cd ')
    # Using a more robust way to handle path expansion and filtering
    # For Zsh:
    if [[ -f "$HOME/.zsh_history" ]]; then
      # Zsh history format: `: timestamp:seconds;cd /path/to/dir`
      grep -E '^: [0-9]+:[0-9]+;cd ' "$HOME/.zsh_history" | \
      sed -E 's/^: [0-9]+:[0-9]+;cd //g' | \
      while IFS= read -r line; do
        # Expand ~ to $HOME using shell parameter expansion
        echo "${line/#~/$HOME}"
      done
    fi
    # If you are using Bash, uncomment the following block and comment out the Zsh block above:
    # if [[ -f "$HOME/.bash_history" ]]; then
    #   grep -E '^cd ' "$HOME/.bash_history" | \
    #   sed -E 's/^cd //g' | \
    #   while IFS= read -r line; do
    #     echo "${line/#~/$HOME}"
    #   done
    # fi

    # 3. Explicitly include your dotfiles bare repo
    echo "$HOME/.dotfiles"

    # 4. Recursively find directories in ~/.config (including hidden ones)
    # -maxdepth 3: Adjust this number to control how deep it searches
    find "$HOME/.config" -maxdepth 3 -type d -print 2>/dev/null

    # 5. Recursively find directories in common notes/project roots
    # Adjust these paths to your actual common project/notes locations
    find "$HOME/Documents/Notes" -maxdepth 3 -type d -print 2>/dev/null
    find "$HOME/Projects" -maxdepth 2 -type d -print 2>/dev/null
    # Add other common paths, e.g.:
    # find "$HOME/Code" -maxdepth 2 -type d -print 2>/dev/null

    # 6. Add current directory and home directory
    echo "$PWD"
    echo "$HOME"
  ) | sort -u | fzf "${_fzf_dir_options[@]}" --query "$1") # sort -u here

  # If a directory was selected, change to it
  if [[ -n "$selected_dir" ]]; then
    cd "$selected_dir"
  fi
}

# --- End fzf for directory navigation ---
