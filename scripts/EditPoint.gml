#define EditPoint


#define edit_highlight_point
edit_clear_highlit_point();

if (_highlit_cube != noone)
{
    var r = edit_find_subcube(_highlit_cube);
    
    // point in world-space
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
inst._cube = cube;

cube._points[sc[0], sc[1]] = inst;

global.Points[global.NumPoints] = inst;
global.NumPoints++;

_highlit_point_saved = inst;

#define edit_remove_point
var cube = argument0;
var sc = argument1;

var pnt = cube._points[sc[0], sc[1]];
var idx = pnt._idx;

global.Points[idx] = noone;
cube._points[sc[0], sc[1]] = noone;

if (pnt._curve != noone)
{
    edit_curve_remove_point(pnt._curve, pnt);
}

edit_deselect_point(pnt);

while(global.NumPoints > 0 && global.Points[global.NumPoints - 1] == noone)
{
    global.NumPoints--;
}


#define edit_select_point
var pnt = argument0;

// stops us getting two of the same point in the list of three
edit_deselect_point(pnt);

global._selected_points[2] = global._selected_points[1];
global._selected_points[1] = global._selected_points[0];
global._selected_points[0] = pnt;


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
#define edit_move_point
var cube = argument0;
var sc = argument1;
var p = argument2;

var pnt = global._selected_points[0];

if (pnt == noone) exit;

if (_highlit_cube == noone) exit;

if (cube != pnt._cube || sc[0] != pnt._sc[0] || sc[1] != pnt._sc[1])
{
    cube._points[pnt._sc[0], pnt._sc[1]] = noone;
    
    pnt._cube = cube;
    pnt._i = cube._i;
    pnt._j = cube._j;
    pnt._sc = copy_coord(sc);
    pnt._p = copy_coord(p);
}
