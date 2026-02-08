-- WezTerm config — tmux-like keybindings with Dark+ theme (macOS)
-- Place this file and set WEZTERM_CONFIG_FILE to point to it,
-- or copy/symlink to ~/.wezterm.lua
local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

---------------------------------------------------------------------------
-- General
---------------------------------------------------------------------------
-- macOS uses zsh by default; no need to override.
-- Uncomment to use a different shell:
-- config.default_prog = { '/bin/zsh', '-l' }
config.scrollback_lines = 10000
config.window_close_confirmation = 'NeverPrompt'

---------------------------------------------------------------------------
-- Appearance
---------------------------------------------------------------------------
config.color_scheme = 'Dark+'
config.font = wezterm.font_with_fallback({
  'JetBrainsMono Nerd Font',
  'JetBrains Mono',
  'Menlo',
})
config.font_size = 14.0
config.window_padding = { left = 2, right = 2, top = 2, bottom = 0 }

-- Hide native macOS title bar and traffic-light buttons; WezTerm renders
-- its own Maximize/Close buttons in the bottom tab bar instead.
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.integrated_title_buttons = { 'Maximize', 'Close' }

config.window_frame = {
  active_titlebar_bg = '#0c0c0c',
  inactive_titlebar_bg = '#0c0c0c',
  active_titlebar_fg = '#ffffff',
  inactive_titlebar_fg = '#888888',
  button_bg = '#0c0c0c',
  button_fg = '#cccccc',
  button_hover_bg = '#333333',
  button_hover_fg = '#ffffff',
}

-- Sensible windowed size when not maximized
config.initial_cols = 142
config.initial_rows = 34

-- Tab bar at bottom, plain style — mimics tmux status line
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 32
config.status_update_interval = 1000

-- Near-black palette
config.colors = {
  background = '#0c0c0c',
  tab_bar = {
    background = '#0c0c0c',
    active_tab = {
      bg_color = '#0078d4',   -- Blue accent
      fg_color = '#ffffff',
      intensity = 'Bold',
    },
    inactive_tab = {
      bg_color = '#1a1a1a',
      fg_color = '#aaaaaa',
    },
    inactive_tab_hover = {
      bg_color = '#2a2a2a',
      fg_color = '#ffffff',
    },
  },
}

---------------------------------------------------------------------------
-- Start maximized (F11 or Ctrl+Cmd+F to toggle native fullscreen)
---------------------------------------------------------------------------
wezterm.on('gui-startup', function(cmd)
  local mux = wezterm.mux
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

---------------------------------------------------------------------------
-- tmux-style tab titles: " 0: title "
---------------------------------------------------------------------------
wezterm.on('format-tab-title', function(tab, _tabs, _panes, _config, _hover, _max_width)
  local title = tab.active_pane.title
  local idx = tab.tab_index
  return string.format(' %d: %s ', idx, title)
end)

---------------------------------------------------------------------------
-- tmux-style left/right status bar
---------------------------------------------------------------------------
wezterm.on('update-status', function(window, _pane)
  -- Left: [workspace]
  local workspace = window:active_workspace()
  window:set_left_status(wezterm.format {
    { Background = { Color = '#0078d4' } },
    { Foreground = { Color = '#ffffff' } },
    { Attribute = { Intensity = 'Bold' } },
    { Text = string.format(' [%s] ', workspace) },
  })

  -- Right: hostname  HH:MM DD-Mon-YY
  local hostname = wezterm.hostname()
  local date = wezterm.strftime '%H:%M %d-%b-%y'
  window:set_right_status(wezterm.format {
    { Background = { Color = '#1a1a1a' } },
    { Foreground = { Color = '#aaaaaa' } },
    { Text = string.format(' %s ', hostname) },
    { Background = { Color = '#0078d4' } },
    { Foreground = { Color = '#ffffff' } },
    { Attribute = { Intensity = 'Bold' } },
    { Text = string.format(' %s ', date) },
  })
end)

---------------------------------------------------------------------------
-- Leader key: Ctrl+B  (tmux default prefix)
-- Press Ctrl+B then the shortcut key within 1 second.
---------------------------------------------------------------------------
config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 1000 }

---------------------------------------------------------------------------
-- Helpers — macOS shifted-key compatibility
---------------------------------------------------------------------------
-- macOS handles shifted keys more consistently than X11/Windows, but
-- provide all three representations for robustness across WezTerm versions.
local function bind_shifted(base_key, shifted_char, mods_prefix, action)
  return {
    { key = shifted_char, mods = mods_prefix,              action = action },
    { key = shifted_char, mods = mods_prefix .. '|SHIFT',  action = action },
    { key = base_key,     mods = mods_prefix .. '|SHIFT',  action = action },
  }
end

local function bind_shifted_letter(letter, mods_prefix, action)
  local lower = letter:lower()
  local upper = letter:upper()
  return {
    { key = upper, mods = mods_prefix,              action = action },
    { key = upper, mods = mods_prefix .. '|SHIFT',  action = action },
    { key = lower, mods = mods_prefix .. '|SHIFT',  action = action },
  }
end

-- Flatten a list of lists into config.keys
local function flatten(tbl, into)
  for _, list in ipairs(tbl) do
    for _, entry in ipairs(list) do
      table.insert(into, entry)
    end
  end
end

---------------------------------------------------------------------------
-- Key bindings
---------------------------------------------------------------------------
config.keys = {
  -- Toggle fullscreen (no leader required)
  -- F11 matches Windows/Debian; native macOS fullscreen also works via
  -- the green traffic-light button or Ctrl+Cmd+F.
  { key = 'F11', mods = 'NONE', action = act.ToggleFullScreen },

  -- Pass Ctrl+B through when pressed twice
  { key = 'b', mods = 'LEADER|CTRL', action = act.SendKey { key = 'b', mods = 'CTRL' } },

  -----------------------------------------------------------------------
  -- Pane splitting
  -----------------------------------------------------------------------
  -- Prefix "  -> top/bottom split  (tmux: split-window)
  -- Prefix %  -> left/right split  (tmux: split-window -h)
  -- Convenience aliases: - and |
  { key = '-', mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

  -----------------------------------------------------------------------
  -- Pane navigation — vim-style (h/j/k/l)
  -----------------------------------------------------------------------
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },

  -----------------------------------------------------------------------
  -- Pane navigation — arrow keys
  -----------------------------------------------------------------------
  { key = 'LeftArrow',  mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'DownArrow',  mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 'UpArrow',    mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'RightArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },

  -----------------------------------------------------------------------
  -- Pane resizing  (Prefix + Shift+h/j/k/l, 5 cells at a time)
  -- Shifted letter variants added below via bind_shifted_letter
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Pane operations
  -----------------------------------------------------------------------
  -- Zoom/unzoom  (Prefix z)
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
  -- Close pane with confirmation  (Prefix x)
  { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },
  -- Cycle to next pane  (Prefix o)
  { key = 'o', mods = 'LEADER', action = act.ActivatePaneDirection 'Next' },
  -- Rotate panes  (Prefix Space)
  { key = 'Space', mods = 'LEADER', action = act.RotatePanes 'Clockwise' },
  -- Swap pane with next/prev  (Prefix { / })  — shifted variants added below

  -----------------------------------------------------------------------
  -- Tab (window) management
  -----------------------------------------------------------------------
  -- New tab  (Prefix c)
  { key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
  -- Next / previous tab  (Prefix n / p)
  { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
  { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
  -- Close tab with confirmation  (Prefix &)  — shifted variants added below

  -- Select tab by index  (Prefix 0-9)
  { key = '0', mods = 'LEADER', action = act.ActivateTab(0) },
  { key = '1', mods = 'LEADER', action = act.ActivateTab(1) },
  { key = '2', mods = 'LEADER', action = act.ActivateTab(2) },
  { key = '3', mods = 'LEADER', action = act.ActivateTab(3) },
  { key = '4', mods = 'LEADER', action = act.ActivateTab(4) },
  { key = '5', mods = 'LEADER', action = act.ActivateTab(5) },
  { key = '6', mods = 'LEADER', action = act.ActivateTab(6) },
  { key = '7', mods = 'LEADER', action = act.ActivateTab(7) },
  { key = '8', mods = 'LEADER', action = act.ActivateTab(8) },
  { key = '9', mods = 'LEADER', action = act.ActivateTab(9) },

  -- Rename tab  (Prefix ,)  — prompts for new name
  { key = ',', mods = 'LEADER', action = act.PromptInputLine {
    description = 'Enter new tab title:',
    action = wezterm.action_callback(function(window, _pane, line)
      if line then
        window:active_tab():set_title(line)
      end
    end),
  }},

  -- Tab/window list  (Prefix w)
  { key = 'w', mods = 'LEADER', action = act.ShowLauncherArgs { flags = 'TABS' } },

  -----------------------------------------------------------------------
  -- Session / workspace
  -----------------------------------------------------------------------
  -- List workspaces  (Prefix s)
  { key = 's', mods = 'LEADER', action = act.ShowLauncherArgs { flags = 'WORKSPACES' } },
  -- New named workspace  (Prefix $)  — shifted variants added below

  -----------------------------------------------------------------------
  -- Copy mode and clipboard  (vim keys built in)
  -----------------------------------------------------------------------
  -- Enter copy mode  (Prefix [)  — navigate with h/j/k/l, select with v, yank with y
  { key = '[', mods = 'LEADER', action = act.ActivateCopyMode },
  -- Paste from clipboard  (Prefix ])
  { key = ']', mods = 'LEADER', action = act.PasteFrom 'Clipboard' },
  -- Search  (Prefix /)
  { key = '/', mods = 'LEADER', action = act.Search 'CurrentSelectionOrEmptyString' },
  -- Quick-select mode  (Prefix f) — highlight and copy URLs, hashes, paths, etc.
  { key = 'f', mods = 'LEADER', action = act.QuickSelect },

  -----------------------------------------------------------------------
  -- Misc
  -----------------------------------------------------------------------
  -- Reload config  (Prefix r)
  { key = 'r', mods = 'LEADER', action = act.ReloadConfiguration },
  -- Show debug overlay / REPL  (Prefix :)  — shifted variants added below
}

---------------------------------------------------------------------------
-- Add shifted-key variants for macOS compatibility
---------------------------------------------------------------------------
local shifted_bindings = {
  -- Pane splitting: " (Shift+')
  bind_shifted("'", '"', 'LEADER', act.SplitVertical { domain = 'CurrentPaneDomain' }),
  -- Pane splitting: % (Shift+5)
  bind_shifted('5', '%', 'LEADER', act.SplitHorizontal { domain = 'CurrentPaneDomain' }),
  -- Pane splitting: | (Shift+\)
  bind_shifted('\\', '|', 'LEADER', act.SplitHorizontal { domain = 'CurrentPaneDomain' }),
  -- Close tab: & (Shift+7)
  bind_shifted('7', '&', 'LEADER', act.CloseCurrentTab { confirm = true }),
  -- New workspace: $ (Shift+4)
  bind_shifted('4', '$', 'LEADER', act.PromptInputLine {
    description = 'Enter workspace name:',
    action = wezterm.action_callback(function(window, pane, line)
      if line then
        window:perform_action(act.SwitchToWorkspace { name = line }, pane)
      end
    end),
  }),
  -- Swap panes: { (Shift+[)
  bind_shifted('[', '{', 'LEADER', act.RotatePanes 'CounterClockwise'),
  -- Swap panes: } (Shift+])
  bind_shifted(']', '}', 'LEADER', act.RotatePanes 'Clockwise'),
  -- Debug overlay: : (Shift+;)
  bind_shifted(';', ':', 'LEADER', act.ShowDebugOverlay),
  -- Pane resizing: Shift+H/J/K/L
  bind_shifted_letter('H', 'LEADER', act.AdjustPaneSize { 'Left',  5 }),
  bind_shifted_letter('J', 'LEADER', act.AdjustPaneSize { 'Down',  5 }),
  bind_shifted_letter('K', 'LEADER', act.AdjustPaneSize { 'Up',    5 }),
  bind_shifted_letter('L', 'LEADER', act.AdjustPaneSize { 'Right', 5 }),
}
flatten(shifted_bindings, config.keys)

---------------------------------------------------------------------------
-- Copy-mode key table (vim bindings)
-- WezTerm ships built-in vim-style copy mode.  The key_tables below add
-- a few extra conveniences on top of the defaults.
---------------------------------------------------------------------------
local copy_mode = nil
if wezterm.gui then
  copy_mode = wezterm.gui.default_key_tables().copy_mode
  -- Add / for search-forward within copy mode
  table.insert(copy_mode, {
    key = '/',
    mods = 'NONE',
    action = act.Search 'CurrentSelectionOrEmptyString',
  })
end

if copy_mode then
  config.key_tables = {
    copy_mode = copy_mode,
  }
end

return config
