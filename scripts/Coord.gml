#define Coord


#define make_coord
var ret;

ret[0] = argument0;
ret[1] = argument1;

return ret;

#define coord_normalised
var x1 = argument0[0];
var y1 = argument0[1];

var len = sqrt(x1 * x1 + y1 * y1);

var ret;

ret[0] = x1 / len;
ret[1] = y1 / len;

return ret;


#define coord_rot90
var x1 = argument0[0];
var y1 = argument0[1];

var ret;
ret[0] = y1;
ret[1] = -x1;

return ret;

#define coord_subtract
var x1 = argument0[0];
var y1 = argument0[1];
var x2 = argument1[0];
var y2 = argument1[1];

var ret;

ret[0] = x1 - x2;
ret[1] = y1 - y2;

return ret;

#define coord_dot
var x1 = argument0[0];
var y1 = argument0[1];
var x2 = argument1[0];
var y2 = argument1[1];

return x1 * x2 + y1 * y2;
#define coord_add
var ret;

ret[0] = argument0[0] + argument1;
ret[1] = argument0[1] + argument2;

return ret;
#define coord_dist
var c = argument0;
var d = argument1;

var dx = c[0] - d[0];
var dy = c[1] - d[1];

return sqrt(dx * dx + dy * dy);


#define coord_dist_2
var cx = argument0;
var cy = argument1;
var dx = argument2;
var dy = argument3;

var dx = cx - dx;
var dy = cy - dy;

return sqrt(dx * dx + dy * dy);


#define coord_mult
var c = argument0;
var s = argument1;

var ret;
ret[0] = c[0] * s;
ret[1] = c[1] * s;

return ret;


#define coord_add_2
var c = argument0;
var d = argument1;

var ret;
ret[0] = c[0] + d[0];
ret[1] = c[1] + d[1];

return ret;
#define coord_copy
var ret;

ret[0] = argument0[0];
ret[1] = argument0[1];

return ret;

