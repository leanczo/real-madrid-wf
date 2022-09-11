import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Time.Gregorian as Calendar;
using Toybox.ActivityMonitor as Act;
using Toybox.Activity as Acty;

class realmadridwfView extends WatchUi.WatchFace {

	var realFont;
	var realFontTiny;
	var realFontXTiny;
	var logo;
	var footstepsIcon;
	var heartIcon;

    function initialize() {
    	realFont = WatchUi.loadResource(Rez.Fonts.realFont);
    	realFontTiny = WatchUi.loadResource(Rez.Fonts.realFontTiny);
    	realFontXTiny = WatchUi.loadResource(Rez.Fonts.realFontXTiny);
        WatchFace.initialize();
    }

    function onLayout(dc as Dc) as Void {
    	logo = WatchUi.loadResource(Rez.Drawables.Logo);
    	footstepsIcon = WatchUi.loadResource(Rez.Drawables.FootstepsIcon);
    	heartIcon = WatchUi.loadResource(Rez.Drawables.HeartIcon);
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    function onShow() as Void {
    }

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
  		
  		// Steps
        dc.drawBitmap(widthCenter -52.5, 5, logo);
        
        var positionXFootstepsIcon = widthScreen / 4 - 12;
        var positionYFootstepsIcon = heightScreen / 8;
        var positionXFootstepsText = widthScreen / 4;
        var positionYFootstepsText = heightScreen*2 / 8;
        
        dc.drawBitmap(positionXFootstepsIcon, positionYFootstepsIcon, footstepsIcon);
        
        var steps = ActivityMonitor.getInfo().steps.toString();
        dc.setColor(getApp().getProperty("ForegroundColor"), Graphics.COLOR_TRANSPARENT);
		dc.drawText(positionXFootstepsText, positionYFootstepsText, realFontXTiny, steps, Graphics.TEXT_JUSTIFY_CENTER);
        
        // Heart
        var positionXHeartIcon = widthScreen * 3 / 4 - 12;
        var positionYHeartIcon = heightScreen / 8;
        var positionXHeartText = widthScreen * 3 / 4;
        var positionYHeartText = heightScreen * 2 / 8;
        
        dc.drawBitmap(positionXHeartIcon, positionYHeartIcon, heartIcon);
        var heartRate = null;
		if (Act has :getHeartRateHistory) 
		{
		 	heartRate = Activity.getActivityInfo().currentHeartRate;

		if(heartRate==null) 
		{
			var HRH=Act.getHeartRateHistory(1, true);
			var HRS=HRH.next();

			if(HRS!=null && HRS.heartRate!= Act.INVALID_HR_SAMPLE)
			{
				heartRate = HRS.heartRate;
			}
		}

		if(heartRate!=null) 
		{
			heartRate = heartRate.toString();
		}
		else
		{
			heartRate = "--";
		}
		}
		
		dc.setColor(getApp().getProperty("ForegroundColor"), Graphics.COLOR_TRANSPARENT);
		dc.drawText(positionXHeartText, positionYHeartText, realFontXTiny, heartRate, Graphics.TEXT_JUSTIFY_CENTER);
		
		// Time
        dc.setColor(getApp().getProperty("ForegroundColor"), Graphics.COLOR_TRANSPARENT);
		dc.drawText(widthCenter, heightCenter - 10, realFont, timeString, Graphics.TEXT_JUSTIFY_CENTER);
		
		
		// Date
		var now = Time.now();
		var info = Calendar.info(now, Time.FORMAT_SHORT);
		var dateStr = Lang.format("$1$-$2$", [info.day,info.month]);
		dc.setColor(Graphics.COLOR_DK_BLUE, Graphics.COLOR_TRANSPARENT);
		dc.drawText(widthCenter, heightScreen - 55, realFontTiny, dateStr, Graphics.TEXT_JUSTIFY_CENTER);
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
