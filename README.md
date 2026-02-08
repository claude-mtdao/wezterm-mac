# wezterm-mac

WezTerm configuration for macOS (Mac Mini M4) that replicates tmux keybindings, vim-style copy mode, and a tmux-like status bar. Themed with Dark+. Unified experience with the Windows and Debian configs.

## Setup

### Option A: Symlink (recommended)

```bash
ln -sf /path/to/wezterm-mac/.wezterm.lua ~/.wezterm.lua
```

### Option B: Environment variable

Add to `~/.zshrc`:

```bash
export WEZTERM_CONFIG_FILE="/path/to/wezterm-mac/.wezterm.lua"
```

Restart your shell or run `source ~/.zshrc`.

### Option C: Home directory copy

```bash
cp .wezterm.lua ~/.wezterm.lua
```

### Prerequisites

- [WezTerm](https://wezfurlong.org/wezterm/) installed in `/Applications` (`.dmg` from [releases](https://github.com/wez/wezterm/releases) or `brew install --cask wezterm`)
- [JetBrains Mono](https://www.jetbrains.com/lp/mono/) font installed:
  ```bash
  # Via Homebrew
  brew install --cask font-jetbrains-mono-nerd-font

  # Or download from https://www.nerdfonts.com/font-downloads
  # and install via Font Book
  ```

## Keybindings

All bindings use the **leader key** `Ctrl+B`, matching the default tmux prefix. Press `Ctrl+B`, release, then press the action key within 1 second.

Press `Ctrl+B` twice to send a literal `Ctrl+B` to the running program.

### Pane splitting

| Key | Action | tmux equivalent |
|-----|--------|-----------------|
| `"` | Split top/bottom | `split-window` |
| `%` | Split left/right | `split-window -h` |
| `-` | Split top/bottom | (convenience alias) |
| `\|` | Split left/right | (convenience alias) |

### Pane navigation

| Key | Action | tmux equivalent |
|-----|--------|-----------------|
| `h` / `Left` | Focus pane left | `select-pane -L` |
| `j` / `Down` | Focus pane below | `select-pane -D` |
| `k` / `Up` | Focus pane above | `select-pane -U` |
| `l` / `Right` | Focus pane right | `select-pane -R` |
| `o` | Cycle to next pane | `select-pane -t :.+` |

### Pane operations

| Key | Action | tmux equivalent |
|-----|--------|-----------------|
| `Shift+H` | Resize left 5 cells | `resize-pane -L 5` |
| `Shift+J` | Resize down 5 cells | `resize-pane -D 5` |
| `Shift+K` | Resize up 5 cells | `resize-pane -U 5` |
| `Shift+L` | Resize right 5 cells | `resize-pane -R 5` |
| `z` | Toggle pane zoom | `resize-pane -Z` |
| `x` | Close pane (confirm) | `kill-pane` |
| `Space` | Rotate panes clockwise | `next-layout` |
| `{` | Rotate counter-clockwise | `swap-pane -U` |
| `}` | Rotate clockwise | `swap-pane -D` |

### Tab (window) management

| Key | Action | tmux equivalent |
|-----|--------|-----------------|
| `c` | New tab | `new-window` |
| `n` | Next tab | `next-window` |
| `p` | Previous tab | `previous-window` |
| `0`–`9` | Select tab by index | `select-window -t :N` |
| `,` | Rename tab | `rename-window` |
| `&` | Close tab (confirm) | `kill-window` |
| `w` | Tab list | `choose-window` |

### Workspaces (sessions)

| Key | Action | tmux equivalent |
|-----|--------|-----------------|
| `s` | List workspaces | `choose-session` |
| `$` | New/switch workspace | `rename-session` / `new-session` |

### Copy mode and search

| Key | Action | tmux equivalent |
|-----|--------|-----------------|
| `[` | Enter copy mode | `copy-mode` |
| `]` | Paste from clipboard | `paste-buffer` |
| `/` | Search | `copy-mode /` |
| `f` | Quick-select (URLs, hashes) | — |

#### Inside copy mode (vim bindings)

| Key | Action |
|-----|--------|
| `h` / `j` / `k` / `l` | Move cursor |
| `w` / `b` / `e` | Word motions |
| `0` / `$` | Start / end of line |
| `g` / `G` | Top / bottom of scrollback |
| `Ctrl+U` / `Ctrl+D` | Half-page up / down |
| `v` | Start character selection |
| `V` | Start line selection |
| `y` | Yank selection to clipboard |
| `/` | Search forward |
| `n` / `N` | Next / previous search match |
| `q` / `Escape` | Exit copy mode |

### Miscellaneous

| Key | Action |
|-----|--------|
| `F11` (direct) | Toggle fullscreen |
| `r` | Reload configuration |
| `:` | Debug overlay / Lua REPL |

## Appearance

- **Theme:** Dark+ with near-black background (`#0c0c0c`)
- **Tab bar:** Bottom, plain style (like tmux status line)
  - Blue active tab, near-black background
  - Left status: `[workspace]` in blue
  - Right status: `hostname` and `HH:MM DD-Mon-YY`
- **Font:** JetBrains Mono at 14pt (fallback: Menlo)
- **Window decorations:** Integrated buttons (macOS traffic-light buttons on the left)
- **Startup mode:** Maximized (press `F11` or click the green traffic light for native fullscreen)
- **Default window size:** 142x34 (cols x rows) when in windowed mode
- **Scrollback:** 10,000 lines

## Inline images

WezTerm supports the iTerm2, Sixel, and Kitty graphics protocols.

### Built-in: `wezterm imgcat`

```bash
wezterm imgcat image.png
```

### Additional tools

| Tool | Install | Usage |
|------|---------|-------|
| `chafa` | `brew install chafa` | `chafa image.png` |
| `timg` | `brew install timg` | `timg image.png` |
| `viu` | `cargo install viu` | `viu image.png` |
| `img2sixel` | `brew install libsixel` | `img2sixel image.png` |

## Zsh enhancements

macOS ships with zsh as the default shell.

### Setup

```bash
# Install tools via Homebrew
brew install fzf zoxide starship

# Set up fzf keybindings and completion
$(brew --prefix)/opt/fzf/install
```

Add to your `~/.zshrc`:

```bash
# fzf integration
source <(fzf --zsh)

# zoxide (smart cd)
eval "$(zoxide init zsh)"

# starship prompt (git status, etc.)
eval "$(starship init zsh)"
```

### fzf keybindings

| Key | Action |
|-----|--------|
| `Ctrl+R` | Fuzzy search command history |
| `Ctrl+T` | Fuzzy find files |
| `Option+C` | Fuzzy cd into subdirectory |

### zoxide (smart cd)

| Command | Action |
|---------|--------|
| `z foo` | Jump to most used directory matching "foo" |
| `z foo bar` | Match path containing both "foo" and "bar" |
| `zi` | Interactive selection with fzf |

### Starship (git-aware prompt)

Starship shows git branch, dirty/clean status, and ahead/behind info. Works identically across your Mac, Debian, and Windows machines.

**Status symbols:**

| Symbol | Meaning |
|--------|---------|
| `main` | Clean — working directory matches last commit |
| `[!]` | Dirty — modified files |
| `[+]` | Staged files ready to commit |
| `[?]` | Untracked files |

To customize, edit `~/.config/starship.toml`.

## Customization

Edit `.wezterm.lua` directly. WezTerm watches the file and auto-reloads on save, or press `Ctrl+B` then `r` to force a reload.

Common tweaks:

```lua
-- Change font size (14pt is tuned for Mac Mini M4 displays)
config.font_size = 13.0

-- Change color scheme
config.color_scheme = 'Gruvbox Dark'

-- Change leader timeout (milliseconds)
config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 2000 }

-- Change leader key to Ctrl+A
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }

-- Increase scrollback
config.scrollback_lines = 50000
```

## tmux concepts vs WezTerm

| tmux | WezTerm |
|------|---------|
| Session | Workspace |
| Window | Tab |
| Pane | Pane |
| Detach (`Prefix d`) | Close the GUI window (sessions persist on mux server) |
| `tmux attach` | `wezterm connect unix` |

### Detach / attach with `wezterm-mux-server`

WezTerm supports tmux-style detach/attach via its built-in multiplexer server.

1. **Start the mux server:**

   ```bash
   wezterm-mux-server --daemonize
   ```

2. **Connect to it:**

   ```bash
   wezterm connect unix
   ```

3. **Detach:** close the WezTerm window — panes, tabs, and scrollback are preserved.

4. **Reattach:** run `wezterm connect unix` again.

**Configuration required** — add a unix domain to `.wezterm.lua`:

```lua
config.unix_domains = {
  { name = 'unix' },
}

-- Optional: connect to the mux server automatically on launch
config.default_gui_startup_args = { 'connect', 'unix' }
```

## Differences from Windows / Debian configs

| Setting | Windows | Debian | Mac |
|---------|---------|--------|-----|
| Shell | PowerShell 7 | Login shell (bash) | Login shell (zsh) |
| Font size | 11pt | 15.5pt (4K) | 14pt |
| Font fallback | Consolas | DejaVu Sans Mono | Menlo |
| Title buttons | All three | Maximize + Close | All three (traffic lights) |
| Fullscreen | F11 | F11 | F11 / green button |
| Colors | Lighter greys | Near-black | Near-black |
| Keybindings | Identical | Identical | Identical |


⏺ The wezterm-mac/ directory is ready. Here's a summary of what was created and the key decisions:                                          
                                                                                                                                            
  Files created                                                                                                                             
  ┌──────────────────────────────────────────────────────┬──────────────────────────────────────────────────────────────┐
  │                         File                         │                           Purpose                            │                   
  ├──────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤                   
  │ .wezterm.lua                                         │ Main config — all tmux keybindings, Dark+ theme, status bar  │
  ├──────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
  │ config-snippets/fullscreen_bottom_window_buttons.lua │ Standalone window frame snippet                              │
  ├──────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
  │ example-starship.toml                                │ Node.js detection for Starship prompt                        │
  ├──────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
  │ README.md                                            │ Setup guide, keybinding reference, cross-platform comparison │
  └──────────────────────────────────────────────────────┴──────────────────────────────────────────────────────────────┘
  Mac-specific adaptations from your existing configs

  - Shell: Uses macOS default zsh (no default_prog needed, unlike Windows PowerShell)
  - Font fallback: Menlo (macOS built-in) instead of Consolas (Win) or DejaVu Sans Mono (Deb)
  - Font size: 14pt — a middle ground between Windows 11pt and Debian 15.5pt (4K), adjustable based on your display
  - Window decorations: INTEGRATED_BUTTONS|RESIZE — all three macOS traffic-light buttons work natively (unlike Debian where minimize was
  broken on X11)
  - Color palette: Near-black scheme from your Debian config (the more refined iteration)
  - Fullscreen: F11 works for consistency, plus macOS native fullscreen via the green traffic-light button

  What's identical across all three

  - Leader key: Ctrl+B (tmux default prefix)
  - All tmux keybindings: pane splitting (", %, -, |), vim navigation (h/j/k/l), resize (Shift+H/J/K/L), zoom (z), tabs (c/n/p/0-9),
  workspaces (s/$), copy mode ([/]), search (/), quick-select (f)
  - Status bar: [workspace] left, hostname HH:MM DD-Mon-YY right
  - Tab titles: 0: title format at bottom

  To activate

  ln -sf ~/Desktop/git/wezterm-mac/.wezterm.lua ~/.wezterm.lua

  Then launch WezTerm from /Applications. It will auto-detect the config.
