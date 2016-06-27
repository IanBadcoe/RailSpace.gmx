#define Tunnel

#define tunnel_store_values
var l = _labels;

if (l == noone) exit;

var ls;
var i = 0;

while(string_length(l) > 0)
{
    var p = string_pos(",", l);
    
    if (p != -1)
    {
        ls[i] = string_copy(l, 1, p - 1);
        l = string_copy(l, p + 1, 1000);
        i++;
    }
}

