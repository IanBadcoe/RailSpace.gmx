#define Misc


#define random_from_array
var a = argument0;

return a[irandom(array_length_1d(a) - 1)];
#define noise
var v = argument0;
var n = argument1;
var h = argument2;

return (sin(v[0] * (n + 0.47675638 + h) / 50) + sin(v[1] * (n + 0.56375879 + h) / 50)) / 2;


#define copy_coord
var p = argument0;

var ret;
ret[0] = p[0];
ret[1] = p[1];

return ret;
#define find_first_curve
var cube = argument0;

var ret;

for(var i = 0; i < 3; i++)
{
    for(var j = 0; j < 3; j++)
    {
        var pnt = cube._points[i, j];

        if (pnt != noone)
        {
            var crv = pnt._curve;
            
            if (crv != noone)
            {
                ret[0] = crv;
                // if there is a next point we're going forwards...
                ret[1] = pnt._next_point != noone;
                
                return ret;
            }
        }
    }
}

return noone;
