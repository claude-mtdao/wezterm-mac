# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

WezTerm configuration for macOS (Mac Mini M4) that replicates tmux keybindings, vim-style copy mode, and a tmux-like status bar. Part of a cross-platform setup (Windows, Debian, macOS) with consistent keybindings and Dark+ theming.

This is a **configuration-only project** — no build system, no tests, no package managers. The entire configuration lives in a single `.wezterm.lua` file written in Lua using WezTerm's built-in API.

## Development Workflow

- Edit `.wezterm.lua` directly — WezTerm watches the file and auto-reloads on save
- Force reload: `Ctrl+B` then `r`
- Debug overlay / Lua REPL: `Ctrl+B` then `:`
- Activation: symlink `.wezterm.lua` to `~/.wezterm.lua`

## Architecture of `.wezterm.lua`

The configuration is structured in this order:

1. **General settings** — scrollback, confirmation prompts, shell
2. **Appearance** — color scheme (Dark+ with `#0c0c0c` background), font (JetBrains Mono Nerd Font 14pt), window decorations (integrated macOS buttons), bottom tab bar styled like tmux
3. **Event handlers** — `gui-startup` (maximize on launch), `format-tab-title` (tmux-style `[index: title]`), `update-status` (left: workspace name, right: hostname + datetime)
4. **Leader key** — `Ctrl+B` with 1000ms timeout (tmux-compatible)
5. **Helper functions** — `bind_shifted()`, `bind_shifted_letter()`, `flatten()` handle macOS shifted-key quirks where both raw shifted characters and shift-modified keys must be bound
6. **Keybindings** — tmux-style bindings behind leader key for pane splitting, navigation (vim h/j/k/l), tab management, workspace switching, copy mode, and quick-select
7. **Shifted keybindings** — pane resizing (`Shift+H/J/K/L`, 5 cells) and symbol variants, generated via helper functions
8. **Copy mode key table** — extends WezTerm's built-in vim copy mode with `/` for search

## Key Design Decisions

- **macOS shifted key handling**: The `bind_shifted()` and `bind_shifted_letter()` helpers exist because macOS sends different key events for shifted keys depending on context. Both the raw character (e.g., `%`) and the shift+base (e.g., `Shift+5`) must be bound.
- **Bottom tab bar as tmux status line**: Uses `tab_bar_at_bottom = true` with `use_fancy_tab_bar = false` to mimic tmux's status bar appearance.
- **Workspace = tmux session**: WezTerm workspaces map to tmux sessions, tabs map to tmux windows, panes map to panes.
- **No shell override**: Respects macOS default zsh rather than forcing a shell configuration.

## File Layout

- `.wezterm.lua` — the entire configuration (346 lines)
- `automator/` — macOS Automator Quick Action ("Open WezTerm Here" Finder service)
- `config-snippets/` — optional standalone snippets (e.g., custom window frame styling)
- `example-starship.toml` — example Starship prompt config for Node.js detection
- `README.md` — setup instructions, keybinding reference, cross-platform comparison
