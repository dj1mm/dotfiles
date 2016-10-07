-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")

-- added to add more widgets on the statusbar
vicious = require("vicious")

-- battery widget!
local battery = require("battery")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({ preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function (err)
		-- Make sure we don't go into an endless error loop
		if in_error then return end
		in_error = true

		naughty.notify({ preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = err })
		in_error = false
	end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("/home/jimmy/.config/awesome/themes/default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "termite" -- changed from xterm
editor = os.getenv("EDITOR") or "vim" -- "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod1" -- "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
	awful.layout.suit.tile,
	awful.layout.suit.floating,
	awful.layout.suit.tile.left,
	awful.layout.suit.tile.bottom,
	awful.layout.suit.tile.top,
	awful.layout.suit.fair,
	awful.layout.suit.fair.horizontal,
	awful.layout.suit.spiral,
	awful.layout.suit.spiral.dwindle,
	awful.layout.suit.max,
	awful.layout.suit.max.fullscreen,
	awful.layout.suit.magnifier
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
	for s = 1, screen.count() do
		gears.wallpaper.maximized(beautiful.wallpaper, s, true)
	end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
	-- Each screen has its own tag table.
	tags[s] = awful.tag({ "⌘ main", "⌥ multimedia", "☃  others", 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
	{ "manual", terminal .. " -e man awesome" },
	{ "edit config", editor_cmd .. " " .. awesome.conffile },
	{ "restart", awesome.restart },
	{ "quit", awesome.quit }
}

mymainmenu = awful.menu({ 
	items = {
		{ "awesome", myawesomemenu, beautiful.awesome_icon },
		{ "open terminal", terminal }
	} 
})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Spaces, Separators
myspace = wibox.widget.textbox()
myspace:set_text(" ")

mycolumn = wibox.widget.textbox()
mycolumn:set_text(" ")

-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- battery widget FROM https://github.com/koenwtje/awesome-batterInfo
mybatterywidget = wibox.widget.textbox()
mybatterywidget_timer = timer({ timeout = 10 }) -- every 10sec update the battery widget lah0
mybatterywidget_timer:connect_signal("timeout", function()
	mybatterywidget:set_text(batteryInfo("BAT0"))
end)
mybatterywidget_timer:start()
mybatterywidget:set_text(batteryInfo("BAT0"))

-- Create the network widget (should show Up kbps and Down kbps) and register it to vicious
-- Note to change wlp8s0 to yr current ethernet/wifi link
vicious.cache(vicious.widgets.net)

myethdownwidget = wibox.widget.textbox()
vicious.register(myethdownwidget, vicious.widgets.net, 'network down ${wlp8s0 down_kb}kbps', 1)

myethdowngraph = awful.widget.graph()
myethdowngraph:set_width(beautiful.graph_width)
myethdowngraph:set_height(beautiful.graph_height)
myethdowngraph:set_border_color(nil)
myethdowngraph:set_background_color(beautiful.bg_graph)
myethdowngraph:set_color({
	type = "linear", 
	from = { 0, beautiful.graph_height }, 
	to = { 0, 0 }, 
	stops = {
		{ 0, "#8b008b" }, 
	}
})
vicious.register(myethdowngraph, vicious.widgets.net, "${wlp8s0 down_kb}", 1)

myethupwidget = wibox.widget.textbox()
vicious.register(myethupwidget, vicious.widgets.net, 'network up ${wlp8s0 up_kb}kbps', 1)

myethupgraph = awful.widget.graph()
myethupgraph:set_width(beautiful.graph_width)
myethupgraph:set_height(beautiful.graph_height)
myethupgraph:set_border_color(nil)
myethupgraph:set_background_color(beautiful.bg_graph)
myethupgraph:set_color({
	type = "linear", 
	from = { 0, beautiful.graph_height }, 
	to = { 0, 0 }, 
	stops = {
		{ 0, "#ff8c00" }, 
	}
})
vicious.register(myethupgraph, vicious.widgets.net, "${wlp8s0 up_kb}", 1)

-- RAM widget
-- heavily copied from github.com/tdy/dots/blob/master/.config/awesome/wi.lua
myramwidget = wibox.widget.textbox()
vicious.register(myramwidget, vicious.widgets.mem, 'ram $2/$3 MB', 1)

-- RAM progress bar
myrambar = awful.widget.progressbar()
myrambar:set_vertical(false)
myrambar:set_width(beautiful.graph_width)
myrambar:set_height(beautiful.graph_height)
myrambar:set_ticks(false)
myrambar:set_ticks_size(2)
myrambar:set_border_color(nil)
myrambar:set_background_color(beautiful.bg_graph)
myrambar:set_color({
	type = "linear", 
	from = { 0, 0 }, 
	to = { 120, 0 }, 
	stops = {
		{ 0, beautiful.fg_graph_normal }, -- low memory usage :) 
		{ 0.7, beautiful.fg_graph_warning },
		{ 0.8, beautiful.fg_graph_beware }, 
		{ 0.9, beautiful.fg_graph_critical }, -- critically using many many ram!!
	}
})
vicious.register(myrambar, vicious.widgets.mem, "$1", 1)

-- required otherwise cpu2, 3 and 4 will constantly show 0%
vicious.cache(vicious.widgets.cpu)

-- CPU widgets
-- Code inspired form github.com/tdy/dots/blob/master/.config/awesome/wi.lua
--
-- cpu1
mycpu1widget = wibox.widget.textbox()
vicious.register(mycpu1widget, vicious.widgets.cpu, "cpu1 $2%", 1) --cpu usage value of 1st cpu

mycpu1graph = awful.widget.graph()
mycpu1graph:set_width(beautiful.graph_width)
mycpu1graph:set_height(beautiful.graph_height)
mycpu1graph:set_border_color(nil)
mycpu1graph:set_background_color(beautiful.bg_graph)
mycpu1graph:set_color({
	type = "linear", 
	from = { 0, beautiful.graph_height }, 
	to = { 0, 0 }, 
	stops = {
		{ 0, beautiful.fg_graph_normal }, 
		{ 0.5, beautiful.fg_graph_warning },
		{ 1, beautiful.fg_graph_critical }, 
	}
})
vicious.register(mycpu1graph, vicious.widgets.cpu, "$2", 1)

-- cpu2
mycpu2widget = wibox.widget.textbox()
vicious.register(mycpu2widget, vicious.widgets.cpu, "cpu2 $3%", 1) --cpu usage value of 2nd cpu

mycpu2graph = awful.widget.graph()
mycpu2graph:set_width(beautiful.graph_width)
mycpu2graph:set_height(beautiful.graph_height)
mycpu2graph:set_border_color(nil)
mycpu2graph:set_background_color(beautiful.bg_graph)
mycpu2graph:set_color({
	type = "linear", 
	from = { 0, beautiful.graph_height }, 
	to = { 0, 0 }, 
	stops = {
		{ 0, beautiful.fg_graph_normal }, 
		{ 0.5, beautiful.fg_graph_warning },
		{ 1, beautiful.fg_graph_critical }, 
	}
})
vicious.register(mycpu2graph, vicious.widgets.cpu, "$3", 1)

-- cpu3
mycpu3widget = wibox.widget.textbox()
vicious.register(mycpu3widget, vicious.widgets.cpu, "cpu3 $4%", 1) --cpu usage value of 3rd cpu

mycpu3graph = awful.widget.graph()
mycpu3graph:set_width(beautiful.graph_width)
mycpu3graph:set_height(beautiful.graph_height)
mycpu3graph:set_border_color(nil)
mycpu3graph:set_background_color(beautiful.bg_graph)
mycpu3graph:set_color({
	type = "linear", 
	from = { 0, beautiful.graph_height }, 
	to = { 0, 0 }, 
	stops = {
		{ 0, beautiful.fg_graph_normal }, 
		{ 0.5, beautiful.fg_graph_warning },
		{ 1, beautiful.fg_graph_critical }, 
	}
})
vicious.register(mycpu3graph, vicious.widgets.cpu, "$4", 1)

-- cpu4
mycpu4widget = wibox.widget.textbox()
vicious.register(mycpu4widget, vicious.widgets.cpu, "cpu4 $5%", 1) --cpu usage value of 3rd cpu

mycpu4graph = awful.widget.graph()
mycpu4graph:set_width(beautiful.graph_width)
mycpu4graph:set_height(beautiful.graph_height)
mycpu4graph:set_border_color(nil)
mycpu4graph:set_background_color(beautiful.bg_graph)
mycpu4graph:set_color({
	type = "linear", 
	from = { 0, beautiful.graph_height }, 
	to = { 0, 0 }, 
	stops = {
		{ 0, beautiful.fg_graph_normal }, 
		{ 0.5, beautiful.fg_graph_warning },
		{ 1, beautiful.fg_graph_critical }, 
	}
})
vicious.register(mycpu4graph, vicious.widgets.cpu, "$5", 1)

-- Create a wibox for each screen and add it
mywibox = {}
mybottombar = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
	awful.button({ }, 1, awful.tag.viewonly),
	awful.button({ modkey }, 1, awful.client.movetotag),
	awful.button({ }, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, awful.client.toggletag),
	awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
	awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
	awful.button({ }, 1, function (c)
		if c == client.focus then
			c.minimized = true
		else
			-- Without this, the following
			-- :isvisible() makes no sense
			c.minimized = false
			if not c:isvisible() then
				awful.tag.viewonly(c:tags()[1])
			end
			-- This will also un-minimize
			-- the client, if needed
			client.focus = c
			c:raise()
		end
	end),
	awful.button({ }, 3, function ()	
		if instance then
			instance:hide()
			instance = nil
		else
			instance = awful.menu.clients({
				theme = { width = 250 }
			})
		end
	end),
	awful.button({ }, 4, function ()
		awful.client.focus.byidx(1)
		if client.focus then client.focus:raise() end
	end),
	awful.button({ }, 5, function ()
		awful.client.focus.byidx(-1)
		if client.focus then client.focus:raise() end
	end))

for s = 1, screen.count() do
	-- Create a promptbox for each screen
	mypromptbox[s] = awful.widget.prompt()
	-- Create an imagebox widget which will contains an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	mylayoutbox[s] = awful.widget.layoutbox(s)
	mylayoutbox[s]:buttons(awful.util.table.join(
		awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
		awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
		awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
		awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)
	))
	-- Create a taglist widget
	mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

	-- Create a tasklist widget
	mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

	-- Create the wibox
	mywibox[s] = awful.wibox({ position = "top", screen = s })
	
	-- Widgets on the top bar that are aligned to the left
	local top_left_layout = wibox.layout.fixed.horizontal()
	top_left_layout:add(mylauncher)
	top_left_layout:add(mytaglist[s])
	top_left_layout:add(mypromptbox[s])
	top_left_layout:add(mylayoutbox[s])
	top_left_layout:add(myspace)

	-- Widgets on the top bar that are aligned to the right
	local top_right_layout = wibox.layout.fixed.horizontal()
	if s == 1 then top_right_layout:add(wibox.widget.systray()) end
	top_right_layout:add(mybatterywidget) -- battery widget
	top_right_layout:add(mycolumn)
	top_right_layout:add(mytextclock)
	top_right_layout:add(myspace)

	-- Now bring it all together (with the tasklist in the middle) on the top bar
	local top_layout = wibox.layout.align.horizontal()
	top_layout:set_left(top_left_layout)
	top_layout:set_middle(mytasklist[s])
	top_layout:set_right(top_right_layout)

	mywibox[s]:set_widget(top_layout)

	-- Create a bottom wibox bar
	mybottombar[s] = awful.wibox({ position = "bottom", screen = s })
	
	local bottom_left_layout = wibox.layout.fixed.horizontal()
	bottom_left_layout:add(myspace)
	bottom_left_layout:add(myethdownwidget) -- network widget and graphs
	bottom_left_layout:add(myethdowngraph)
	bottom_left_layout:add(mycolumn)
	bottom_left_layout:add(myethupwidget) -- network widget and graphs
	bottom_left_layout:add(myethupgraph)

	local bottom_right_layout = wibox.layout.fixed.horizontal()
	bottom_right_layout:add(myramwidget)
	bottom_right_layout:add(myrambar)
	bottom_right_layout:add(mycolumn)
	bottom_right_layout:add(mycpu1widget)
	bottom_right_layout:add(mycpu1graph)
	bottom_right_layout:add(mycolumn)
	bottom_right_layout:add(mycpu2widget)
	bottom_right_layout:add(mycpu2graph)
	bottom_right_layout:add(mycolumn)
	bottom_right_layout:add(mycpu3widget)
	bottom_right_layout:add(mycpu3graph)
	bottom_right_layout:add(mycolumn)
	bottom_right_layout:add(mycpu4widget)
	bottom_right_layout:add(mycpu4graph)
	bottom_right_layout:add(myspace)

	local bottom_layout = wibox.layout.align.horizontal()
	bottom_layout:set_left(bottom_left_layout)
	bottom_layout:set_right(bottom_right_layout)

	mybottombar[s]:set_widget(bottom_layout)
	
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
	awful.button({ }, 3, function () mymainmenu:toggle() end),
	awful.button({ }, 4, awful.tag.viewnext),
	awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
	awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
	awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
	awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

	awful.key({ modkey,           }, "j",
	function ()
		awful.client.focus.byidx( 1)
		if client.focus then client.focus:raise() end
	end),
	awful.key({ modkey,           }, "k",
	function ()
		awful.client.focus.byidx(-1)
		if client.focus then client.focus:raise() end
	end),
	awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

	-- Layout manipulation
	awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
	awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
	awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
	awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
	awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
	awful.key({ modkey,           }, "Tab",
	function ()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
		end
	end),

	-- Standard program
	awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
	awful.key({ modkey, "Control" }, "r", awesome.restart),
	awful.key({ modkey, "Shift"   }, "q", awesome.quit),

	awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
	awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
	awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
	awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
	awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
	awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
	awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
	awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

	awful.key({ modkey, "Control" }, "n", awful.client.restore),

	-- Prompt
	awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

	awful.key({ modkey }, "x",
	function ()
		awful.prompt.run({ prompt = "Run Lua code: " },
		mypromptbox[mouse.screen].widget,
		awful.util.eval, nil,
		awful.util.getdir("cache") .. "/history_eval")
	end),
	-- Menubar
	awful.key({ modkey }, "p", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
	awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
	awful.key({ modkey, 		  }, "q",      function (c) c:kill()                         end),
	awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
	awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
	awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
	awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
	awful.key({ modkey,           }, "n",
	function (c)
		-- The client currently has the input focus, so it cannot be
		-- minimized, since minimized clients can't have the focus.
		c.minimized = true
	end),
	awful.key({ modkey,           }, "m",
	function (c)
		c.maximized_horizontal = not c.maximized_horizontal
		c.maximized_vertical   = not c.maximized_vertical
	end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	globalkeys = awful.util.table.join(globalkeys,
	-- View tag only.
	awful.key({ modkey }, "#" .. i + 9,
	function ()
		local screen = mouse.screen
		local tag = awful.tag.gettags(screen)[i]
		if tag then
			awful.tag.viewonly(tag)
		end
	end),
	-- Toggle tag.
	awful.key({ modkey, "Control" }, "#" .. i + 9,
	function ()
		local screen = mouse.screen
		local tag = awful.tag.gettags(screen)[i]
		if tag then
			awful.tag.viewtoggle(tag)
		end
	end),
	-- Move client to tag.
	awful.key({ modkey, "Shift" }, "#" .. i + 9,
	function ()
		if client.focus then
			local tag = awful.tag.gettags(client.focus.screen)[i]
			if tag then
				awful.client.movetotag(tag)
			end
		end
	end),
	-- Toggle tag.
	awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
	function ()
		if client.focus then
			local tag = awful.tag.gettags(client.focus.screen)[i]
			if tag then
				awful.client.toggletag(tag)
			end
		end
	end))
end

clientbuttons = awful.util.table.join(
	awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
	awful.button({ modkey }, 1, awful.mouse.client.move),
	awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{ rule = { },
	properties = { border_width = beautiful.border_width,
		border_color = beautiful.border_normal,
		focus = awful.client.focus.filter,
		raise = true,
		keys = clientkeys,
		buttons = clientbuttons } },
	{ rule = { class = "MPlayer" },
		properties = { floating = true } },
	{ rule = { class = "pinentry" },
		properties = { floating = true } },
	{ rule = { class = "gimp" },
		properties = { floating = true } },
	{ rule = { class = "Termite" }, 
		},
	-- Set Firefox to always map on tags number 2 of screen 1.
	{ rule = { class = "Firefox" },
		properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
	-- Enable sloppy focus
	c:connect_signal("mouse::enter", function(c)
		if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
			and awful.client.focus.filter(c) then
			client.focus = c
		end
	end)

	if not startup then
		-- Set the windows at the slave,
		-- i.e. put it at the end of others instead of setting it master.
		-- awful.client.setslave(c)

		-- Put windows in a smart way, only if they does not set an initial position.
		if not c.size_hints.user_position and not c.size_hints.program_position then
			awful.placement.no_overlap(c)
			awful.placement.no_offscreen(c)
		end
	end

	local titlebars_enabled = false
	if awful.rules.match(c, { class = "Termite" }) then 
		titlebars_enabled = true
	end
	if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
		-- buttons for the titlebar
		local buttons = awful.util.table.join(
		awful.button({ }, 1, function()
			client.focus = c
			c:raise()
			awful.mouse.client.move(c)
		end),
		awful.button({ }, 3, function()
			client.focus = c
			c:raise()
			awful.mouse.client.resize(c)
		end)
		)

		-- Widgets that are aligned to the left
		local top_left_layout = wibox.layout.fixed.horizontal()
		top_left_layout:add(awful.titlebar.widget.iconwidget(c))
		top_left_layout:buttons(buttons)

		-- Widgets that are aligned to the right
		local top_right_layout = wibox.layout.fixed.horizontal()
		-- top_right_layout:add(awful.titlebar.widget.floatingbutton(c))
		-- top_right_layout:add(awful.titlebar.widget.maximizedbutton(c))
		-- top_right_layout:add(awful.titlebar.widget.stickybutton(c))
		-- top_right_layout:add(awful.titlebar.widget.ontopbutton(c))
		-- top_right_layout:add(awful.titlebar.widget.closebutton(c))

		-- The title goes in the middle
		local top_middle_layout = wibox.layout.flex.horizontal()
		local title = awful.titlebar.widget.titlewidget(c)
		-- title:set_align("center")
		top_middle_layout:add(title)
		top_middle_layout:buttons(buttons)

		-- Now bring it all together
		local layout = wibox.layout.align.horizontal()
		layout:set_left(top_left_layout)
		layout:set_right(top_right_layout)
		layout:set_middle(top_middle_layout)

		awful.titlebar(c):set_widget(layout)
	end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- }}}

-- {{{ Autostart apps

awful.util.spawn(terminal)

-- }}}
