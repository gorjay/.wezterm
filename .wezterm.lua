local wezterm = require("wezterm")
local act = wezterm.action
local config = {}

config = wezterm.config_builder()

-- config.color_scheme = "Catppuccin Mocha"
-- config.color_scheme = "Catppuccin Macchiato"
config.color_scheme = "Seafoam Pastel (Gogh)"

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    config.default_prog = { "C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe" }
end
config.window_background_opacity = 1.0
config.warn_about_missing_glyphs = false
config.check_for_updates = false

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
    { key = "a", mods = "LEADER|CTRL", action = act.SendKey({ key = "a", mods = "CTRL" }),},
    { key = "n", mods = "LEADER|CTRL", action = act.SendString 'printf "\\e]9;%s\\e\\\\" "finished"'},
    { key = "b", mods = "LEADER|CTRL", action = act.EmitEvent("toggle-opacity"),},
    { key = 'Tab', mods = 'CTRL', action = act.ActivateLastTab,},
    { key = "-", mods = "LEADER|CTRL", action = act.SplitVertical { domain = "CurrentPaneDomain" },},
    { key = "\\",mods = "LEADER|CTRL", action = act.SplitHorizontal { domain = "CurrentPaneDomain" },},
    { key = "h", mods = "LEADER|CTRL", action = act.ActivatePaneDirection("Left"),},
    { key = "j", mods = "LEADER|CTRL", action = act.ActivatePaneDirection("Down"),},
    { key = "k", mods = "LEADER|CTRL", action = act.ActivatePaneDirection("Up"),},
    { key = "l", mods = "LEADER|CTRL", action = act.ActivatePaneDirection("Right"),},
    { key = 'w', mods = 'LEADER|CTRL', action = act.PaneSelect{ alphabet = '1234567890', }},
    { key = ',', mods = 'LEADER|CTRL', action = act.PaneSelect{ alphabet = '1234567890', mode = 'SwapWithActive' }},
    { key = 'H', mods = 'LEADER', action = act.AdjustPaneSize { 'Left', 5 }, },
    { key = 'J', mods = 'LEADER', action = act.AdjustPaneSize { 'Down', 5 }, },
    { key = 'K', mods = 'LEADER', action = act.AdjustPaneSize { 'Up', 5 } },
    { key = 'L', mods = 'LEADER', action = act.AdjustPaneSize { 'Right', 5 }, },
    { key = 'z', mods = 'CTRL', action = act.TogglePaneZoomState,},
    { key = 'q', mods = 'LEADER|CTRL', action = wezterm.action.CloseCurrentPane { confirm = true },},
}
config.mouse_bindings = {
    { event = { Down = { streak = 1, button = { WheelUp = 1 } } }, mods = "CTRL", action = act.IncreaseFontSize,    },
    { event = { Down = { streak = 1, button = { WheelDown = 1 } } }, mods = "CTRL",    action = act.DecreaseFontSize, },
}

-- F1 through F8 to activate that tab
for i = 1, 8 do
  table.insert(config.keys, {
    key = 'F' .. tostring(i),
    action = wezterm.action.ActivateTab(i - 1),
  })
end

wezterm.on("toggle-opacity", function(window, pane)
    local overrides = window:get_config_overrides() or {}
    if not overrides.window_background_opacity then
        overrides.window_background_opacity = 0.8
    else
        overrides.window_background_opacity = nil
    end
    window:set_config_overrides(overrides)
end)

return config
