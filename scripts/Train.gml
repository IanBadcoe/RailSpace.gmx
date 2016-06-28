#define Train


#define train_create_player_train
var inst = instance_create(0, 0, obPlayerEngine);

with inst
{
    train_attach_wagon(obFlatbed);
    train_attach_wagon(obFlatbed);
}

return inst;


#define train_speed_for_regulator
return _regulator * _power / _total_weight / 25;


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

    if (_curve_dir)
    {
        _curve_pos += _speed;
    }
    else
    {
        _curve_pos -= _speed;
    }
}

train_calc_position();

if (_coupled_backwards == noone) exit;

var next_pos;

if (_curve_dir)
{
    next_pos = _curve_pos - _length - 4;
}
else
{
    next_pos = _curve_pos + _length + 4;
}

_coupled_backwards._curve_pos = next_pos;

with _coupled_backwards train_step_inner();

if (_heading_to != noone) exit;

// only engine calculates this...
if (_power == 0) exit;

var tunnel = noone;

if (_curve_pos > _curve._length && _curve_dir)
{
    tunnel = train_get_tunnel(_curve._points[_curve._num_points - 1]);
}
else if (_curve_pos < 0 && !_curve_dir)
{
    tunnel = train_get_tunnel(_curve._points[0]);
}

if (tunnel != noone)
{
    _heading_to = tunnel._to_tnl;
}

if (_heading_to != noone)
{    
    alarm_set(0, tunnel._time * 30);
    
    if (_player_train)
    {
        obRoomControllerPlay._force_camera_to = _heading_to._p;
        obRoomControllerPlay._camera_time = tunnel._time * 30;
    }
}


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
grid_draw_vertex_3(tc[0], 0, 0);
grid_draw_vertex_3(tc[1], 0, 1);
grid_draw_vertex_3(tc[2], 1, 0);
grid_draw_vertex_3(tc[3], 1, 1);
draw_primitive_end();


#define train_get_tunnel
var pnt = argument0;

var cube = pnt._cube;

var tnl = cube._tunnel;

return tnl;


#define train_follow_track_from_tunnel
var tnl = argument0;

var cube = tnl._cube;
var curve_data = find_first_curve(cube);

if (curve_data != noone)
{     
    train_follow_curve(curve_data[0], curve_data[1], 3);
}

#define train_follow_curve
var crv = argument0;
var d = argument1;
var reg = argument2;

_regulator = reg;
_speed = train_speed_for_regulator();

if (d != 0)
{
    _curve_pos = 0;
    
}
else
{
    _curve_pos = crv._length;
}


train_set_curve(crv, d);

#define train_set_curve
var crv = argument0;
var dir = argument1;

_curve = crv;
_curve_dir = dir;
_h = crv._h;

with _coupled_backwards train_set_curve(crv, dir);
#define train_attach_wagon
var obj = argument0;

var inst = instance_create(0, 0, obj);

var last = train_find_end();

last._coupled_backwards = inst;
inst._coupled_forwards = last;

_total_weight += inst._weight;


#define train_find_end
var inst = self;

while(inst._coupled_backwards != noone)
{
    inst = inst._coupled_backwards;
}

return inst;

