#define Curve

#define curve_pos
var crv = argument0;
var pos = argument1;

var path = crv._path;

var path_pos = pos / crv._length;

var ret;

ret[0] = path_get_x(path, path_pos);
ret[1] = path_get_y(path, path_pos);

return ret;
