#define Edit


#define edit_highlight_cube
var col = argument0;

// allow us to lock to a cube for track point editing on their very edges
if (keyboard_check(vk_shift)) exit;

edit_clear_highlit_cube();

var cube = edit_find_cube();

if (cube != noone)
{
    _highlit_cube = cube;
    cube._highlit = true;
    cube._highlight_colour = col;
}


#define edit_find_cube
for(var h = global.MaxHeights - 1; h >= 0; h--)
{
    var cube = edit_find_cube_level(h);
    
    if (cube != noone)
    {
        return cube;
    }
}

return noone;


#define edit_find_cube_level
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


#define edit_clear_highlit_cube
if (_highlit_cube != noone)
{
    _highlit_cube._highlit = false;
    _highlit_cube = noone;
}


#define edit_highlight_point
if (_highlit_cube != noone)
{
    var r = edit_find_subcube(_highlit_cube);
    
    // point in screen-space
    _highlit_point[0] = r[2];
    _highlit_point[1] = r[3];

    // also the flag that we have a point    
    _highlit_point_cube = _highlit_cube;

    // coord [0 - 3] within cube
    _highlit_point_subcube[0] = r[0];
    _highlit_point_subcube[1] = r[2];
}


#define edit_clear_highlit_point
_highlit_point_cube = noone;

#define edit_find_subcube
var cube = argument0;

var h = cube._h;

var pers = grid_perspective(h);

var hx = window_mouse_get_x() - global.ScreenCentreX;
var hy = window_mouse_get_y() - global.ScreenCentreY;

hx = hx / pers + _focus_x;
hy = hy / pers + _focus_y;

var i = floor(hx / (global.SquareSize / 3));
var j = floor(hy / (global.SquareSize / 3));

var ri = clamp((i - cube._i * 3), 0, 3);
var rj = clamp((j - cube._j * 3), 0, 3);

// recalc global sub-cube position allowing for limits of current cube...
i = cube._i * 3 + ri;
j = cube._j * 3 + rj;

var ret;

ret[0] = ri;
ret[1] = rj;
ret[2] = (i * (global.SquareSize / 3) - _focus_x) * pers + global.ScreenCentreX;
ret[3] = (j * (global.SquareSize / 3) - _focus_y) * pers + global.ScreenCentreY;

return ret;