#define View

#define view_reset
var lock_pos = argument0

global.ScreenWidth = window_get_width();
global.ScreenHeight = window_get_height();;

global.ScreenCentreX = global.ScreenWidth / 2;
global.ScreenCentreY = global.ScreenHeight / 2;
global.ScreenCentre[0] = global.ScreenCentreX;
global.ScreenCentre[1] = global.ScreenCentreY;

view_xport[0] = 0;
view_yport[0] = 0;
view_hport[0] = global.ScreenHeight;
view_wport[0] = global.ScreenWidth;

view_hview[0] = global.ScreenHeight;
view_wview[0] = global.ScreenWidth;
if (lock_pos)
{
    view_xview[0] = 0;
    view_yview[0] = 0;
}


