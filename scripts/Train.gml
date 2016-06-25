#define Train

#define train_create_player_train
var inst = instance_create(0, 0, obEngine);

inst._total_weight = inst._weight;

return inst;


#define train_follow_curve
var trn = argument0;
var crv = argument1;
var dir = argument2;
var reg = argument3;

trn._curve = crv;
trn._curve_dir = dir;
trn._regulator = reg;
trn._speed = train_speed_for_regulator(trn, reg);
trn._h = crv._h;

if (dir)
{
    trn._curve_pos = 0;
    
}
else
{
    trn._curve_pos = 1;
}


#define train_speed_for_regulator
var trn = argument0;
var reg = argument1;

return reg * trn._power / trn._total_weight / 50;


#define train_step
var trn = argument0;

// when we have more than one rolling-stock, abort here unless we're the first
// let first cascade into us instead

// not on track
if (trn._curve == noone) exit;

train_update_speed(trn);

train_update_position(trn);


#define train_update_speed
var trn = argument0;

trn._speed = (trn._speed * 10 + train_speed_for_regulator(trn, trn._regulator)) / 11;


#define train_update_position
var trn = argument0;

trn._curve_pos += trn._speed;

trn._front_p = curve_pos(trn._curve, trn._curve_pos);


var back_pos;

if (trn._curve_dir)
{
    back_pos = trn._curve_pos - trn._length;
}
else
{
    back_pos = trn._curve_pos + trn._length;
}

trn._back_p = curve_pos(trn._curve, back_pos);


#define train_draw
var fx = argument0;
var fy = argument1;
var trn = argument2;

if (trn._front_p == noone) exit;

var d = coord_subtract(trn._front_p, trn._back_p);
var w = coord_mult(coord_rot90(d), trn._width_ratio / 2);

var c;
c[0] = coord_add_2(trn._front_p, w);
c[1] = coord_subtract(trn._front_p, w);
c[2] = coord_add_2(trn._back_p, w);
c[3] = coord_subtract(trn._back_p, w);

var tc;

for(var i = 0; i < 4; i++)
{
    tc[i] = grid_transform(fx, fy, c[i], trn._h, false);
}

draw_primitive_begin_texture(pr_trianglestrip, sprite_get_texture(trn.sprite_index, 0));
grid_draw_vertex_3(tc[0], 0, 0);
grid_draw_vertex_3(tc[1], 0, 1);
grid_draw_vertex_3(tc[2], 1, 0);
grid_draw_vertex_3(tc[3], 1, 1);
draw_primitive_end();
