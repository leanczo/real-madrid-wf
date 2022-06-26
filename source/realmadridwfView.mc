import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Time.Gregorian as Calendar;

class realmadridwfView extends WatchUi.WatchFace {

	var realFont;
	var realFontTiny;
	var image;

    function initialize() {
    	realFont = WatchUi.loadResource(Rez.Fonts.realFont);
    	realFontTiny = WatchUi.loadResource(Rez.Fonts.realFontTiny);
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
    	image = WatchUi.loadResource(Rez.Drawables.Logo);
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Get the current time and format it correctly
        var timeFormat = "$1$:$2$";
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
                hours = hours.format("%02d");
            }
        }
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        
        var widthScreen = dc.getWidth();
		var heightScreen = dc.getHeight();
  		var heightCenter = heightScreen / 2;
  		var widthCenter = widthScreen / 2;
  		var heightLogo = heightScreen / 9;
  		
        dc.drawBitmap(widthCenter -52.5, 5, image);
        
        dc.setColor(getApp().getProperty("ForegroundColor"), Graphics.COLOR_TRANSPARENT);
		dc.drawText(widthCenter + 5 , heightCenter - 10, realFont, timeString, Graphics.TEXT_JUSTIFY_CENTER);
		
		var now = Time.now();
		var info = Calendar.info(now, Time.FORMAT_SHORT);
		var dateStr = Lang.format("$1$-$2$", [info.day,info.month]);
		dc.setColor(Graphics.COLOR_DK_BLUE, Graphics.COLOR_TRANSPARENT);
		dc.drawText(widthCenter + 5 , heightCenter + 60, realFontTiny, dateStr, Graphics.TEXT_JUSTIFY_CENTER);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
