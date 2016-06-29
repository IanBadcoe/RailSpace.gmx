#define EditCurve

#define edit_new_curve
var p1 = argument0;
var p2 = argument1;

var crv = instance_create(0, 0, obCurve);

crv._points[0] = p1;
crv._points[1] = p2;
crv._h = p1._h;
crv._num_points = 2;
crv._idx = global.NumCurves;

p1._curve = crv;
p1._next_point = p2;

p2._curve = crv;
p2._prev_point = p1;

global.Curves[global.NumCurves] = crv;
global.NumCurves++;

with crv edit_curve_recalc();


#define edit_curve_add_point_end
var crv = argument0;
var p = argument1;

p._curve = crv;
p._prev_point = crv._points[crv._num_points - 1];
crv._points[crv._num_points - 1]._next_point = p;

crv._points[crv._num_points] = p;
crv._num_points++;

with crv edit_curve_recalc();


#define edit_curve_add_point_begin
var crv = argument0;
var p = argument1;

p._curve = crv;
p._next_point = crv._points[0];
crv._points[0]._prev_point = p;

for(var i = 0; i < crv._num_points; i++)
{
    var t = crv._points[i];
    crv._points[i] = p;
    p = t;
}

crv._points[crv._num_points] = p;
crv._num_points++;

with crv edit_curve_recalc();


#define edit_curve_remove_point
var crv = argument0;
var pnt = argument1;

var j = 0;
for(var i = 0; i < crv._num_points; i++)
{
    crv._points[j] = crv._points[i];
    
    if (crv._points[j] != pnt)
        j++;
}

crv._points[crv._num_points - 1] = noone;
crv._num_points--;

if (pnt._prev_point != noone)
    pnt._prev_point._next_point = pnt._next_point;

if (pnt._next_point != noone)
    pnt._next_point._prev_point = pnt._prev_point;

if (crv._num_points < 2)
{
    global.Curves[crv._idx] = noone;
    with (crv) instance_destroy();
}
else
{
    with crv edit_curve_recalc();
}
    
while(global.NumCurves > 0 && global.Curves[global.NumCurves - 1] == noone)
{
    global.NumCurves--;
}


#define edit_curve_recalc
if (_path != noone)
{
    path_delete(_path);
}

_path = path_add();

path_set_closed(_path, false);
path_set_kind(_path, 1);
path_set_precision(_path, 4);

for(var i = 0; i < _num_points; i++)
{
    path_add_point(_path, _points[i]._p[0], _points[i]._p[1], 100);
}

var len = 0;

var pcx = path_get_x(_path, 0);
var pcy = path_get_y(_path, 0);

for(var i = 0.01; i < 1; i += 0.01)
{
    var cx = path_get_x(_path, i);
    var cy = path_get_y(_path, i);
    
    len += coord_dist_2(pcx, pcy, cx, cy);
    
    pcx = cx;
    pcy = cy;
}

var cx = path_get_x(_path, 1);
var cy = path_get_y(_path, 1);

len += coord_dist_2(pcx, pcy, cx, cy);

_length = len;
