#define Misc


#define random_from_array
var a = argument0;

return a[irandom(array_length_1d(a) - 1)];
#define noise
var v = argument0;
var n = argument1;

return (sin(v[0] * (n + 0.47675638)) + sin(v[1] * (n + 0.56375879))) / 2;

