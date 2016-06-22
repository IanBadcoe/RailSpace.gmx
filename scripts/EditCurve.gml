#define EditCurve

#define edit_new_curve
var p1 = argument0;
var p2 = argument1;

var crv = instance_create(0, 0, obCurve);

crv._points[0] = p1;
crv._points[1] = p2;
crv._h = p1._h;
crv._num_points = 2;

p1._curve = crv;
p1._next_point = p2;

p2._curve = crv;
p2._prev_point = p1;

global.Curves[global.NumCurves] = crv;
global.NumCurves++;


#define edit_curve_add_point_end
var crv = argument0;
var p = argument1;

p._curve = crv;
p._prev_point = crv._points[crv._num_points - 1];
crv._points[crv._num_points - 1]._next_pnt = p;

crv._points[crv._num_points] = p;
crv._num_points++;


#define edit_curve_add_point_begin
var crv = argument0;
var p = argument1;

p._curve = crv;
p._next_point = crv._points[0];
crv._points[0]._prev_pnt = p;

for(var i = 0; i < crv._num_points; i++)
{
    var t = crv._points[i];
    crv._points[i] = p;
    p = t;
}

crv._points[crv._num_points] = p;
crv._num_points++;

