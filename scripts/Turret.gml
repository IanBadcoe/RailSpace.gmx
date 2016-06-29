#define Turret

#define wagon_attach_turret
var ob = argument0;
var pos = argument1;
var wgn = argument2;
var enemy = argument3;

var inst = instance_create(0, 0, ob);

inst._wagon = wgn;
wgn._turrets[pos] = inst;
inst._pos = pos;
inst._enemy_turret = enemy;

return inst;


#define turret_draw
var fx = argument0;
var fy = argument1;
var truck_rear = argument2;
var truck_axis = argument3;
var h = argument4;

var offset = 1/4;

if (_pos == 1) offset = 3/4;

_p = coord_add_2(truck_rear, coord_mult(truck_axis, offset));

var ff = pi / 4;

var sa = sin(_angle + ff);
var ca = cos(_angle + ff);

var c;
c[0] = make_coord(_p[0] + sa * 10, _p[1] + ca * 10);
c[1] = make_coord(_p[0] + ca * 10, _p[1] - sa * 10);
c[2] = make_coord(_p[0] - sa * 10, _p[1] - ca * 10);
c[3] = make_coord(_p[0] - ca * 10, _p[1] + sa * 10);

var tc;

for(var i = 0; i < 4; i++)
{
    tc[i] = grid_transform(fx, fy, c[i], h, false);
}

draw_primitive_begin_texture(pr_trianglestrip, sprite_get_texture(sprite_index, 0));
grid_draw_vertex_3(tc[0], 0, 0);
grid_draw_vertex_3(tc[1], 0, 1);
grid_draw_vertex_3(tc[3], 1, 0);
grid_draw_vertex_3(tc[2], 1, 1);
draw_primitive_end();


#define turret_step
if (_enemy_turret)
{
    if (global.PlayerTrain == noone) exit;

    var dx = global.PlayerTrain._p[0] - _p[0];
    var dy = global.PlayerTrain._p[1] - _p[1];
    
    _angle = arctan2(dx, dy);
}

