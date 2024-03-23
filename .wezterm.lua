local wezterm = require("wezterm")
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Basic
-- config.color_scheme = "Monokai Pro (Gogh)"
-- config.color_scheme = "Batman"
config.color_scheme = "Catppuccin Mocha"
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_prog = { "C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe" }
end
config.window_background_opacity = 1.0
config.warn_about_missing_glyphs = false
config.check_for_updates = false

-- Function
wezterm.on("toggle-opacity", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	if not overrides.window_background_opacity then
		overrides.window_background_opacity = 0.8
	else
		overrides.window_background_opacity = nil
	end
	window:set_config_overrides(overrides)
end)

--- Key bindings
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
	{
		key = "a",
		mods = "LEADER|CTRL",
		action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }),
	},
	-- Toggle opacity
	{
		key = "b",
		mods = "LEADER|CTRL",
		action = wezterm.action.EmitEvent("toggle-opacity"),
	},
}
-- for i = 1, 8 do
--   -- ALT + number to activate that tab
--   table.insert(config.keys, {
--     key = tostring(i),
--     mods = 'ALT',
--     action = wezterm.action.ActivateTab(i - 1),
--   })
--   -- F1 through F8 to activate that tab
--   table.insert(config.keys, {
--     key = 'F' .. tostring(i),
--     action = wezterm.action.ActivateTab(i - 1),
--   })
-- end

config.mouse_bindings = {
	-- Scrolling up while holding CTRL increases the font size
	{
		event = { Down = { streak = 1, button = { WheelUp = 1 } } },
		mods = "CTRL",
		action = wezterm.action.IncreaseFontSize,
	},

	-- Scrolling down while holding CTRL decreases the font size
	{
		event = { Down = { streak = 1, button = { WheelDown = 1 } } },
		mods = "CTRL",
		action = wezterm.action.DecreaseFontSize,
	},
}

-- and finally, return the configuration to wezterm
return config
