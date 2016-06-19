#define Misc

#define random_from_array
var a = argument0;

return a[irandom(array_length_1d(a) - 1)];
#define make_coord
var ret;

ret[0] = argument0;
ret[1] = argument1;

return ret;
