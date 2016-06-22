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

hx = hx / pers + global._focus_x;
hy = hy / pers + global._focus_y;

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
edit_clear_highlit_point();

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
    _highlit_point_subcube[1] = r[1];
    
    _highlit_point_cube._show_grid = true;
    
    _highlit_point_saved = _highlit_point_cube._points[_highlit_point_subcube[0], _highlit_point_subcube[1]];
}


#define edit_clear_highlit_point
if (_highlit_point_cube != noone)
{
    _highlit_point_cube._show_grid = false;
}

_highlit_point_cube = noone;

#define edit_find_subcube
var cube = argument0;

var h = cube._h;

var pers = grid_perspective(h);

var hx = window_mouse_get_x() - global.ScreenCentreX;
var hy = window_mouse_get_y() - global.ScreenCentreY;

hx = hx / pers + global._focus_x;
hy = hy / pers + global._focus_y;

var i = floor(hx / (global.SquareSize / 3));
var j = floor(hy / (global.SquareSize / 3));

var ri = clamp((i - cube._i * 3), 0, 2);
var rj = clamp((j - cube._j * 3), 0, 2);

// recalc global sub-cube position allowing for limits of current cube...
i = (cube._i + (ri + 0.5) / 3) * global.SquareSize;
j = (cube._j + (rj + 0.5) / 3) * global.SquareSize;

var ret;

ret[0] = ri;
ret[1] = rj;
ret[2] = i;
ret[3] = j;

return ret;

#define edit_set_cube_height
var cube = argument0;
var h = argument1;

if (h < 0 || h >= global.MaxHeights) exit;

var hi = cube._i;
var hj = cube._j;

global.RoomGrid[hi, hj] = h;
_last_height = h;
            
for(var i = max(hi - 1, 0); i <= min(hi + 1, global.TilesWidth - 1); i++)
{
    for(var j = max(hj - 1, 0); j <= min(hj + 1, global.TilesHeight - 1); j++)
    {
        grid_make_cube(i, j);
    }
}


#define edit_add_point
var cube = argument0;
var sc = argument1;
var p = argument2;

var inst = instance_create(0, 0, obPoint);

inst._h = cube._h;
inst._p = copy_coord(p);
inst._sc = copy_coord(sc);
inst._i = cube._i;
inst._j = cube._j;
inst._idx = global.NumPoints;

cube._points[sc[0], sc[1]] = inst;

global.Points[global.NumPoints] = inst;
global.NumPoints++;

_highlit_point_saved = true;

#define edit_remove_point
var cube = argument0;
var sc = argument1;

var pnt = cube._points[sc[0], sc[1]];
var idx = pnt._idx;

global.Points[idx] = noone;
cube._points[sc[0], sc[1]] = noone;

edit_deselect_point(pnt);

while(global.NumPoints > 0 && global.Points[global.NumPoints - 1] == noone)
{
    global.NumPoints--;
}


#define edit_select_point
var pnt = argument0;

if (edit_point_is_selected(pnt))
{
    edit_deselect_point(pnt);
}
else
{
    global._selected_points[2] = global._selected_points[1];
    global._selected_points[1] = global._selected_points[0];
    global._selected_points[0] = pnt;
}


#define edit_deselect_point
var pnt = argument0;

var removing = false;

if (pnt == global._selected_points[0])
{
    global._selected_points[0] = global._selected_points[1];
    removing = true;
}

if (removing || pnt == global._selected_points[1])
{
    global._selected_points[1] = global._selected_points[2];
    removing = true;
}

if (removing || pnt == global._selected_points[2])
{
    global._selected_points[2] = noone;
}


#define edit_point_is_selected
var pnt = argument0;

return pnt == global._selected_points[0] ||
    pnt == global._selected_points[1] ||
    pnt == global._selected_points[2];
