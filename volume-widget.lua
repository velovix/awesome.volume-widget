local wibox = require("wibox")
local awful = require("awful")
require("math")
require("string")

local Volume = { mt = {}, wmt = {} }
Volume.wmt.__index = Volume
Volume.__index = Volume

config = awful.util.getdir("config")

local function run(command)
	local prog = io.popen(command)
	local result = prog:read('*all')
	prog:close()
	return result
end

function Volume:new(args)
	local obj = setmetatable({}, Volume)

	obj.step = args.step or 5
	obj.device = args.device or "Master"

	-- Create imagebox widget
	obj.widget = wibox.widget.imagebox()
	obj.widget:set_resize(false)
	obj.widget:set_image(config.."/awesome.volume-widget/icons/0.png")

	-- Add a tooltip to the imagebox
	obj.tooltip = awful.tooltip({ objects = { K },
		timer_function = function() return obj:tooltipText() end } )
	obj.tooltip:add_to_object(obj.widget)

	-- Check the volume every 5 seconds
	obj.timer = timer({ timeout = 5 })
	obj.timer:connect_signal("timeout", function() obj:update({}) end)
	obj.timer:start()

	obj:update()

	return obj
end

function Volume:tooltipText()
	return string.sub(self:getVolume(), 0, 2).."% Volume"
end

function Volume:update(status)
	local b = self:getVolume()
	local img = math.floor((b/100)*5)
	self.widget:set_image(config.."/awesome.volume-widget/icons/"..img..".png")
end

function Volume:up()
	run("amixer set " .. self.device .. " " .. self.step .. "%+")
	self:update({})
end

function Volume:down()
	run("amixer set " .. self.device .. " " .. self.step .. "%-")
	self:update({})
end

function Volume:getVolume()
	local result = run("amixer get " .. self.device)
	return string.gsub(string.match(result, "%[%d*%%%]"), "%D", "")
end

function Volume.mt:__call(...)
    return Volume.new(...)
end

return Volume
