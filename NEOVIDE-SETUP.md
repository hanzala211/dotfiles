# Florian-based Neovide setup

Ubuntu x86-64. Run the installer as your normal user.

## Fresh installation

```bash
sudo apt-get update && sudo apt-get install -y git
git clone --branch main https://github.com/hanzala211/dotfiles.git ~/dotfiles && bash ~/dotfiles/install-neovide.sh
source ~/.bashrc
nv
```

## Existing checkout

```bash
cd ~/dotfiles
git status --short
git pull --ff-only
bash ./install-neovide.sh
source ~/.bashrc
nv
```

Commit or back up local changes before pulling.

## Launch commands

- `nv`: graphical editor with this profile.
- `nv .`: open the current project.
- `nvim-florian`: terminal editor with the pinned Neovim binary.
- `env -u NVIM_APPNAME /usr/bin/nvim`: original profile, if system Neovim exists.

## Custom shortcuts

- Space then e: toggle the file sidebar.
- Ctrl-backslash: toggle the terminal.
- 2 then Ctrl-backslash in normal mode: terminal 2.
- 3 then Ctrl-backslash in normal mode: terminal 3.

Terminal settings and mappings are stored in the committed Lua configuration.

## Notes

The installer preserves the original ~/.config/nvim.
Existing standalone Florian configurations are moved to timestamped backups.
Neovim and Neovide binaries are pinned and checksum-verified.
lazy-lock.json should be committed.
Go, gopls, Node, and optional external plugin tools are not installed by this script.
Official binaries require compatible system libraries and a working graphical environment.
Do not update plugins blindly while stabilizing the configuration.
