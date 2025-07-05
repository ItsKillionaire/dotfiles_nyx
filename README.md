This repository contains my dotfiles for an Arch Linux setup running Hyprland. These configurations aim for a cohesive, efficient, and functional environment.

⚙️ Components Included

This repository specifically tracks the following configuration directories, all located within ~/.config/:

    🖼️ Hyprland: Configuration for my Wayland compositor, including keybindings, window rules, and visual settings.

    📊 Waybar: Configuration for my Wayland bar, featuring modules for system status and workspace navigation.

    📸 Hyprshot: A screenshot utility for Hyprland.

    🐱 Kitty: Terminal emulator configuration, including colors and fonts.

    🎨 Wal (Pywal): Configuration for dynamic color scheme generation based on wallpaper.

    🚪 Wlogout: Logout menu for Wayland.

    🔍 Wofi: Wayland launcher for applications and commands.

    🔔 SwayNC: Notification daemon for Wayland.

🛠️ How to Use These Dotfiles

This repository uses the bare Git repository method for managing dotfiles directly in the home directory.

Prerequisites:

    git installed

    ssh key set up with GitHub (for cloning via SSH)

Installation Steps:

    Backup existing dotfiles (recommended):

    mkdir -p ~/dotfiles_backup
    mv ~/.config/hypr ~/dotfiles_backup/hypr_bak
    # Repeat for waybar, kitty, etc. if they exist and you want to keep them

    Initialize the bare repository:

    git init --bare $HOME/.dotfiles

    Create an alias for easy interaction:
    Add the following line to your shell's configuration file (e.g., ~/.bashrc, ~/.zshrc, ~/.config/fish/config.fish):

    alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

    Then, source your shell config:

    source ~/.bashrc # Or your shell's equivalent

    Configure the bare repository:
    This prevents dotfiles status from showing every untracked file in your home directory.

    dotfiles config --local status.showUntrackedFiles no

    Clone the dotfiles:
    Pull the contents of this repository into your home directory.

    dotfiles remote add origin git@github.com:ItsKillionaire/dotfiles_nyx.git
    dotfiles pull origin main --allow-unrelated-histories

    The --allow-unrelated-histories flag is necessary for the initial pull if the GitHub repository was initialized with a README.md.

    Handle potential conflicts:
    If you had existing files that conflict with the ones in this repo (e.g., a ~/.config/hypr folder), Git might report conflicts. Resolve these manually by deciding whether to keep your old file or overwrite it with the one from the repo.

        To overwrite local files with repo versions (use with caution!):

        dotfiles checkout main --force

        To keep your local files and untrack them (if you prefer your local version not to be managed by this repo):

        # Add the file to ~/.gitignore first
        echo ".config/hypr/my_local_file.conf" >> ~/.gitignore
        dotfiles rm --cached ~/.config/hypr/my_local_file.conf
        dotfiles add ~/.gitignore
        dotfiles commit -m "Untracked local file"
        dotfiles push

    Dependencies:
    Ensure required applications and fonts are installed (e.g., Hyprland, Waybar, Kitty, Pywal, Wlogout, Wofi, SwayNC, Nerd Fonts).

    Apply Changes:
    Restart Hyprland or log out/in for changes to take effect.

🔄 Updating Dotfiles

To pull the latest changes from this repository:

dotfiles pull

To push your local changes to this repository:

dotfiles add . # Or specific files/folders you've changed
dotfiles commit -m "Descriptive commit message"
dotfiles push

🤝 Contributing & Feedback

Explore, fork, and adapt these dotfiles. For suggestions, improvements, or issues, open an issue or pull request.
📜 Credits & Inspiration

    Inspired by various dotfile repositories on GitHub.

    Special thanks to the Arch Linux and Hyprland communities for their excellent software and documentation.

Enjoy your Arch Linux experience. ✨
