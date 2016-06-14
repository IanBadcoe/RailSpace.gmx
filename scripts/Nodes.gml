#define Nodes


#define Coord2Node
return floor(argument0 / global.NodeSize);

#define NodeVal
var hx = argument0 ^ 0xf7e4;
var hy = argument1 ^ 0x539c;

var hv = (hx * 17 + hy * 13 + hx * hy);
hv = ((hv ^ (hv >> 8)) & 0xff);

#define Node2Coord
return argument0 * global.NodeSize;
