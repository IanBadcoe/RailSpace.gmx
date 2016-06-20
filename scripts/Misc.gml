#define Misc


#define random_from_array
var a = argument0;

return a[irandom(array_length_1d(a) - 1)];
#define noise
var v = argument0;
var n = argument1;

v[0] *= 1.85298592;
v[1] *= 1.85298592;

if (n)
{
    return (v[0] % 7 + v[1] % 11 + v[0] % 4 + v[1] % 12 - 17) / 17;
}

return (v[0] % 9 + v[1] % 13 + v[0] % 6 + v[1] % 14 - 21) / 21;
