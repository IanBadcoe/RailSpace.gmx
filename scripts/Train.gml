#define Train

#define train_create_player_train
var inst = instance_create(0, 0, obEngine);

inst._total_weight = inst._weight;

var wgn = instance_create(0, 0, obFlatbed);
inst._coupled_backwards = wgn;
wgn._coupled_forwards = inst;

return inst;


#define train_follow_curve
var crv = argument0;
var dir = argument1;
var reg = argument2;

_regulator = reg;
_speed = train_speed_for_regulator();

if (dir)
{
    _curve_pos = 0;
    
}
else
{
    _curve_pos = 1;
}


train_set_curve(crv, dir);

#define train_set_curve
var crv = argument0;
var dir = argument1;

_curve = crv;
_curve_dir = dir;
_h = crv._h;

with _coupled_backwards train_set_curve(crv, dir);


#define train_speed_for_regulator
return _regulator * _power / _total_weight / 50;


#define train_step
// abort here unless we're the first wagon in the train
// let first cascade into us instead

if (_coupled_forwards != noone) exit;

train_step_inner();


#define train_step_inner
// not on track
if (_curve == noone) exit;

// only engine calculates this...
if (_power != 0)
{
    train_update_speed();

    _curve_pos += _speed;
}

train_calc_position();

if (_coupled_backwards == noone) exit;

var next_pos;

if (_curve_dir)
{
    next_pos = _curve_pos + _length + 4;
}
else
{
    next_pos = _curve_pos - _length - 4;
}

_coupled_backwards._curve_pos = next_pos;

with _coupled_backwards train_step_inner();


#define train_update_speed
_speed = (_speed * 10 + train_speed_for_regulator()) / 11;


#define train_calc_position
_front_p = curve_pos(_curve, _curve_pos);

var back_pos;

if (_curve_dir)
{
    back_pos = _curve_pos + _length;
}
else
{
    back_pos = _curve_pos - _length;
}

_back_p = curve_pos(_curve, back_pos);


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
grid_draw_vertex_3(tc[0], 1, 0);
grid_draw_vertex_3(tc[1], 1, 1);
grid_draw_vertex_3(tc[2], 0, 0);
grid_draw_vertex_3(tc[3], 0, 1);
draw_primitive_end();