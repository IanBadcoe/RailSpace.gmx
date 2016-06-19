#define Edit

#define edit_find_mouse
if (_highlit_cube != noone)
{
    _highlit_cube._highlit = false;
    _highlit_cube = noone;
}

for(var h = global.MaxHeights - 1; h >= 0; h--)
{
    var cube = edit_find_mouse_level(h);
    
    if (cube != noone)
    {
        _highlit_cube = cube;
        cube._highlit = true;
        exit;
    }
}


#define edit_find_mouse_level
var h = argument0;

var pers = grid_perspective(h);

var hx = window_mouse_get_x() - global.ScreenCentreX;
var hy = window_mouse_get_y() - global.ScreenCentreY;

hx = hx / pers + _focus_x;
hy = hy / pers + _focus_y;

var i = floor(hx / global.SquareSize);
var j = floor(hy / global.SquareSize);

if (i < 0 || i >= global.TilesWidth || j < 0 || j >= global.TilesHeight)
{
    return noone;
}

if (global.RoomGrid[i, j] == h)
{
    return global.RoomCubes[i, j];
}

return noone;
