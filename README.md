# dotfiles

> “We become what we behold. We shape our tools and then our tools shape us”.

My personal dotfiles, including a Go-focused Neovim setup and a Florian-based Neovide profile.

## Neovim profiles

- `nvim/`: my original Neovim configuration.
- `nvim-florian/`: my saved Florian-based configuration with custom shortcuts and terminal integration.

Neovide is the graphical frontend. Neovim runs the configuration and plugins.

The installer uses the configuration saved in this repository—not a fresh copy of Florian's upstream configuration.

## Requirements

- Ubuntu on x86-64 hardware.
- Bash for the commands below.
- Internet access.
- Sudo permission to install Ubuntu packages.
- A working graphical desktop and compatible system libraries.

Run the installer as your normal user. Do not run it with `sudo bash`.

## What gets installed

The installer:

1. Installs supporting Ubuntu packages, including Git, curl, build tools, ripgrep, clipboard tools, fonts, and fortune.
2. Downloads Neovim 0.11.6 and Neovide 0.16.2.
3. Verifies both downloads with SHA-256 checksums.
4. Installs the binaries under `~/.local/share/neovide-setup/`.
5. Links the saved Florian profile into the Neovim configuration directory.
6. Creates the `nv` and `nvim-florian` launch commands.
7. Adds PATH, profile selection, and the `nv` alias to Bash.
8. Creates a `Neovide (Florian)` application-menu entry.
9. Restores plugin revisions from `lazy-lock.json` when available.

The original `~/.config/nvim` and `/usr/bin/nvim` are not replaced.

Selected existing files are backed up under:

```text
~/neovim-backups/install-<timestamp>/
```

This is not a complete backup of your home directory or plugin data.

Go, gopls, Node, and optional external plugin tools are not installed by the script.

## Fresh installation: step by step

Use this flow only when `~/dotfiles` does not already exist.

All Bash commands below go in your Ubuntu terminal.

### 1. Install Git

```bash
sudo apt-get update &&
sudo apt-get install -y git
```

Expected output: package updates followed by Git installation, or a message that Git is already installed.

### 2. Clone this repository

```bash
git clone --branch main \
  [https://github.com/hanzala211/dotfiles.git](https://github.com/hanzala211/dotfiles.git) \
  ~/dotfiles

cd ~/dotfiles
```

Expected output:

```text
Cloning into '/home/<user>/dotfiles'...
Receiving objects: ...
Resolving deltas: ...
```

Do not clone over an existing nonempty directory. Use the existing-checkout instructions below instead.

### 3. Review and run the installer

```bash
less install-neovide.sh
```

Press `q` to leave the viewer, then run:

```bash
bash ./install-neovide.sh
```

Expected output includes:

```text
... package installation ...
/tmp/.../nvim.tar.gz: OK
/tmp/.../neovide.tar: OK
Restoring plugin revisions from lazy-lock.json...
... plugin output ...

Installed successfully.
Configuration: /home/<user>/.config/nvim-florian
Backups: /home/<user>/neovim-backups/install-<timestamp>
Run: source ~/.bashrc
Then: nv
Terminal editor: nvim-florian
```

Paths differ if XDG_CONFIG_HOME is customized.

If there is no lockfile, the installer reports that plugins will install on first launch.

Stop and investigate checksum, library, or configuration errors rather than assuming a partial installation succeeded.

### 4. Activate Bash settings

```bash
source ~/.bashrc
```

Usually there is no output, although existing shell startup code may print messages.

### 5. Open Neovide

```bash
nv
```

Expected result: Neovide opens with the saved profile and the terminal prompt returns.

## Fresh installation: one-command flow

After reviewing the installer, run this on a fresh Ubuntu machine where `~/dotfiles` does not exist:

```bash
sudo apt-get update &&
sudo apt-get install -y git &&
git clone --branch main [https://github.com/hanzala211/dotfiles.git](https://github.com/hanzala211/dotfiles.git) ~/dotfiles &&
bash ~/dotfiles/install-neovide.sh &&
source ~/.bashrc &&
nv
```

## Update or reinstall an existing checkout

Close editors using this profile before reinstalling.

First check the branch and local changes:

```bash
cd ~/dotfiles
git branch --show-current
git status --short
```

Proceed when the branch is `main` and the status output is empty.

If there are local changes, commit or back them up first.

Then:

```bash
git pull --ff-only &&
bash ./install-neovide.sh &&
source ~/.bashrc &&
nv
```

Expected output: `Already up to date.` or downloaded Git changes, followed by installer output.

If Git refuses the update because the history diverged, stop. Do not use a forced reset or force-push as a shortcut.

## Launch commands

| Command | Action |
| --- | --- |
| `nv` | Open Neovide with the saved profile and pinned Neovim binary. |
| `nv .` | Open the current project. |
| `nv main.go` | Open a file. |
| `nvim-florian` | Open the saved profile in terminal Neovim. |
| `nvim-florian .` | Open the current project in terminal Neovim. |

You can also launch `Neovide (Florian)` from Ubuntu's application menu.

Use `nv` and `nvim-florian` to select the installer-managed binaries reliably. Plain `nvim` and `neovide` may use existing system installations.

## Verify the selected configuration

Inside Neovide, press Escape and enter:

```vim
:echo stdpath('config')
```

Expected output with standard Ubuntu paths:

```text
/home/<user>/.config/nvim-florian
```

Alternatively, run from the Ubuntu terminal:

```bash
nvim-florian --headless \
  -c 'echo stdpath("config")' \
  -c 'qa!'

readlink -f ~/.config/nvim-florian
```

The resolved configuration link should point to:

```text
/home/<user>/dotfiles/nvim-florian
```

Commands beginning with `:` belong inside Neovim or Neovide—not directly at a Bash prompt.

## Custom shortcuts

Space is the leader key. Press Space and the following letters sequentially.

| Shortcut | Action |
| --- | --- |
| Space, then `e` | Toggle the left Neo-tree file sidebar. |
| Ctrl+backslash | Open or hide the terminal. |
| `1`, then Ctrl+backslash in normal mode | Toggle terminal session 1. |
| `2`, then Ctrl+backslash in normal mode | Toggle terminal session 2. |
| `3`, then Ctrl+backslash in normal mode | Toggle terminal session 3. |

If already typing inside a terminal, press Ctrl+backslash followed by Ctrl+N to enter terminal-normal mode before using a numeric prefix.

Useful commands inside Neovide:

```vim
:Neotree toggle filesystem left
:1ToggleTerm
:2ToggleTerm
:TermSelect
:ToggleTermToggleAll
```

Hiding a terminal does not exit its shell.

## Increase terminal height

Edit:

```text
nvim-florian/lua/conf/plugins/hanzallah_terminal.lua
```

For a default height of 25 lines, set:

```lua
size = 25,
```

Close and reopen Neovide after changing the default.

To resize the current terminal immediately:

1. Focus the terminal.
2. Press Ctrl+backslash followed by Ctrl+N.
3. Enter:

```vim
:resize 25
```

The existing `persist_size = true` setting preserves an adjusted size between toggles during the session.

Commit the configuration change if you want the same default on another machine.

## Go development

Install a suitable Go toolchain separately.

Check it in the Ubuntu terminal:

```bash
go version
```

Open a Go project:

```bash
cd /path/to/your/go/project
nv .
```

Open a `.go` file.

Inside Neovide, install gopls if needed:

```vim
:MasonInstall gopls
```

Restart the editor, then check:

```vim
:checkhealth vim.lsp
:lua print(vim.inspect(vim.lsp.get_clients({ bufnr = 0 })))
```

Expected result: a `gopls` client is attached to the Go buffer.

Installing gopls alone does not guarantee that the saved LSP configuration enables it.

Test language features:

```vim
:lua vim.lsp.buf.hover()
:lua vim.lsp.buf.definition()
:lua vim.lsp.buf.format({ async = false })
```

Resolve LSP or save-hook errors before adding another formatter. Formatting and organizing imports are separate operations.

## Clipboard check

Inside Neovide:

```vim
:checkhealth vim.provider
```

In normal mode, copy the current line to the system clipboard:

```vim
"+yy
```

Paste into another application to verify it.

The installer includes xclip and wl-clipboard. Provider availability still depends on the desktop session.

## Save and push future changes

The active profile is linked to the repository, so configuration edits are visible to Git.

Review and stage:

```bash
cd ~/dotfiles

git status --short

git diff -- \
  nvim-florian install-neovide.sh README.md NEOVIDE-SETUP.md

git add -- \
  nvim-florian install-neovide.sh README.md NEOVIDE-SETUP.md

git diff --cached --stat
git diff --cached
```

Check for secrets, personal paths, and accidental backup files.

Then commit only these paths and push:

```bash
git commit --only \
  -m "Update Neovide configuration and documentation" \
  -- nvim-florian install-neovide.sh README.md NEOVIDE-SETUP.md

git push
```

Keep `nvim-florian/lazy-lock.json` committed to record plugin revisions.

## Plugin recovery

Use `:Lazy` to inspect plugins.

Avoid running `:Lazy sync` indiscriminately while troubleshooting because it may update plugin versions.

If an update breaks a previously working setup:

1. Restore a known-good committed `lazy-lock.json`.
2. Run inside Neovide:

```vim
:Lazy restore
```

This restores plugin revisions from the lockfile, not Lua configuration or external tools.

## Troubleshooting

### nv: command not found

Run in the Ubuntu terminal:

```bash
source ~/.bashrc
~/.local/bin/nv
```

If the absolute command works, inspect your PATH and shell settings.

The installer configures Bash, not every shell.

### fortune: not found

```bash
sudo apt-get install -y fortune-mod fortunes-min
/usr/games/fortune
```

The installer-managed launchers already add `/usr/games` to PATH.

### Sidebar or terminal shortcuts do not work

Inside Neovide:

```vim
:verbose nmap <Space>e
:verbose nmap <C-\>
:verbose tmap <C-\>
```

Test the commands directly:

```vim
:Neotree toggle filesystem left
:ToggleTerm
```

If direct commands work, investigate mapping overrides. If commands are missing, inspect plugin installation with `:Lazy`.

### Checksum or shared-library errors

Stop if checksum verification fails. Do not bypass verification.

For GLIBC or missing-library errors, check Ubuntu compatibility rather than replacing system libraries blindly.

A successful binary version check does not guarantee the graphical window can render correctly.

### Existing launcher conflict

The installer refuses to overwrite an existing `~/.local/bin/nv` or `~/.local/bin/nvim-florian` that does not have its managed marker.

Inspect and back up the conflicting file before deciding whether to move it.

## Return to the original configuration

If system Neovim exists:

```bash
env -u NVIM_APPNAME /usr/bin/nvim
```

Or use the installer-managed binary:

```bash
env -u NVIM_APPNAME \
  ~/.local/share/neovide-setup/neovim-0.11.6/bin/nvim
```

Open the original profile in Neovide:

```bash
env -u NVIM_APPNAME PATH="$PATH:/usr/games" \
  ~/.local/share/neovide-setup/neovide-0.16.2/neovide \
  --fork \
  --neovim-bin "$HOME/.local/share/neovide-setup/neovim-0.11.6/bin/nvim"
```

On a fresh machine, first link the original configuration if it is not already installed. Check that `~/.config/nvim` does not exist before running:

```bash
mkdir -p ~/.config
ln -s ~/dotfiles/nvim ~/.config/nvim
```

To stop selecting Florian by default in Bash, remove the NVIM_APPNAME exports from `~/.bashrc`, then run:

```bash
unset NVIM_APPNAME
```

The explicit `nv` and `nvim-florian` wrappers will still select Florian.

## Other dotfiles

The repository also contains Alacritty, tmux, Zsh, Git, and CLI configuration. These are separate from the Neovide installer.

After inspecting and backing up existing destination files, optional links include:

```bash
mkdir -p ~/.config

ln -s ~/dotfiles/alacritty ~/.config/alacritty
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.p10k.zsh ~/.p10k.zsh
ln -s ~/dotfiles/.gitconfig ~/.gitconfig
```

Do not delete existing configurations merely to make these commands succeed. Review personal paths and settings before enabling shell or Git configuration.

Review the existing script-linking helper before using it:

```bash
less ~/dotfiles/symlink_dotfiles.sh
```

The `llm/` templates are optional. Install the llm tool first and use the appropriate configuration location for your platform.

For the shorter installation guide, see [NEOVIDE-SETUP.md](NEOVIDE-SETUP.md).
