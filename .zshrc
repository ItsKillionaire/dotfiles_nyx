# =============================================================================
# 1. Environment Variables & PATH
# =============================================================================
# Set your preferred default editor
export EDITOR="/usr/bin/nvim"
export VISUAL="/usr/bin/nvim"
export TERMINAL=kitty

# Add custom directories to your executable path
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"
export PATH="$HOME/scripts:$PATH"
export PATH="$PATH:$HOME/development/flutter/bin"

# =============================================================================
# 2. Oh My Zsh Configuration
# =============================================================================
# Path to your Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set to blank to disable OMZ themes and use Starship instead
ZSH_THEME=""

# List of Oh My Zsh plugins to use
plugins=(git)

# This loads the Oh My Zsh framework
source "$ZSH/oh-my-zsh.sh"

# =============================================================================
# 3. Appearance (Pywal & Starship)
# =============================================================================
# Load colors from pywal at the start of the session
[ -f "$HOME/.cache/wal/sequences" ] && cat "$HOME/.cache/wal/sequences"

# [Function] Sets system-wide color scheme from an image using pywal.
waltheme() {
    if [ -z "$1" ]; then
        echo "Usage: waltheme /path/to/image.jpg"
        return 1
    fi
    wal -i "$1" -o "$HOME/.config/wal/sequences"
}

# Initialize Starship Prompt - MUST BE LAST for prompt configuration
eval "$(starship init zsh)"

# =============================================================================
# 4. Tool Configuration (Bun & FZF)
# =============================================================================
# Bun shell completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# --- FZF Configuration ---
# FZF keybindings and fuzzy completion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# FZF visual settings
export FZF_DEFAULT_OPTS='
--height 50% --reverse --border=rounded
--prompt="  " --pointer="󰄶 "
--color="fg:#d8dee9,hl:#81a1c1,fg+:#d8dee9,hl+:#81a1c1"
--color="bg+:#3b4252,preview-bg:#3b4252,border:#4c566a"
--preview="bat --color=always --style=numbers --line-range=:500 {}"
--bind="ctrl-d:page-down,ctrl-u:page-up"
'

# [Function] Fuzzy find a directory and jump to it.
zf() {
    local selected_dir
    selected_dir=$(fd --type d --hidden --exclude .git --exclude node_modules . "$HOME" | fzf)
    [ -n "$selected_dir" ] && cd "$selected_dir"
}

# [Function] Fuzzy find a file (or files) and open it in Neovim.
vf() {
    local files file
    files=$(fd --type f --hidden --exclude .git --exclude node_modules . "$HOME" | fzf)
    for file in $(echo "$files"); do
        [ -n "$file" ] && nvim "$file"
    done
}

# =============================================================================
# 5. Custom Aliases & Functions
# =============================================================================
# --- Aliases ---
# Quickly attach or create a tmux session.
alias t='tmux attach || tmux new-session'
# Manage dotfiles using a bare git repository.
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
# Shortcut to my CS50 course notes directory.
alias cs50="cd /home/killionaire/Documents/Notes/cs50webprogramming"
# Set wallpaper using a custom script.
alias setwal='/home/killionaire/scripts/setwal.sh'

# --- Termux Connection Functions ---
# Mounts the Termux filesystem onto the local ~/Termux directory.
mount-phone() {
    echo ">>> Mounting Termux phone files on ~/Termux..."
    echo ">>> Make sure sshd is running on your phone!"
    sshfs -f -p 8022 -o follow_symlinks u0_a619@192.168.68.56:/data/data/com.termux/files/home ~/Termux
}

# Safely unmounts the Termux filesystem.
unmount-phone() {
    echo ">>> Unmounting ~/Termux..."
    fusermount -u ~/Termux
    echo ">>> Done."
}
