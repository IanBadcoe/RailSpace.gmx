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
