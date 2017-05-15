# Volume Widget
Provides a simple volume widget for the Awesome window manager. It displays the
current volume with an icon and allows you to adjust the volume when you press
the volume up and down buttons on your keyboard, if you have them.

### Dependencies
No extra Awesome libraries are required, but the widget does use the
`amixer` command.

### Setup
1. Navigate to your Awesome config directory (usually `~/.config/awesome`) and
   clone this repository with the following command:

	```
	git clone https://github.com/velovix/awesome.volume-widget
	```

2. Create a symlink for the volume-widget.lua file. This is done so that
   your rc.lua can find the code, and so you can update the widget by simply
   pulling in changes from this repository later. While still in the Awesome
   config directory, run the following:

	```
	ln -s awesome.volume-widget/volume-widget.lua volume-widget.lua
	```

3. In your rc.lua, add the following near the beginning of the file. This loads
   up the library and has you access it through the new volume_widget table
   we're creating.

	```
	local volume_widget = require("volume-widget")
	```

4. Add the following line near the beginning of your rc.lua, but after the line
   in the previous step. Providing an empty table sets all configurations to
   their defaults. This should work for most users. See the configuration
   section if you think you're special.

	```
	local volume = volume_widget:new({})
	```

5. Add the following lines near where other similar key bindings are being made
   in the rc.lua. This will allow you to control volume with your
   volume keys on your keyboard.

	```
	awful.key({}, "XF86AudioRaiseVolume", function() volume:down() end),
	awful.key({}, "XF86AudioLowerVolume", function() volume:up() end),
	```

6. Finally, to add your widget to the bar, you'll have to add the following
   line somewhere after the `right_layout` table is created.

	```
	right_layout:add(volume.widget)
	```

7. Restart Awesome WM and you're finished! You should see a white volume
   icon on the top right of the screen!

### Configuration
For most cases, the default configuration will work fine.  Unless you know for
sure that you're different, you should try this first and see what kind of
results you get. If you do need special configuration options, there are six
provided. Feed them into your `new` function instead of the default empty
table.

- **step**: The amount that the volume should be incremented or decremented.
  The default is `5`.
- **channel**: The channel that the widget should be modifying the volume of.
  the default is `Master`.
