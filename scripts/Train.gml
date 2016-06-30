#define Train




#define train_create_player_train
var inst = instance_create(0, 0, obPlayerEngine);

with inst
{
    var wgn = train_attach_wagon(obFlatbed, false);
    wagon_attach_turret(obRifle, 0, wgn, false);
    wagon_attach_turret(obMissileTurret, 1, wgn, false);
    wgn = train_attach_wagon(obFlatbed, false);
    wagon_attach_turret(obRifle, 0, wgn, false);
    wagon_attach_turret(obMissileTurret, 1, wgn, false);
}

return inst;


#define train_speed_for_regulator
return _regulator * _power / _total_weight / 25;


#define train_step
// abort here unless we're the first wagon in the train
// let first cascade into us instead

if (_coupled_forwards == noone)
{
    train_step_inner();
}

depth = -_h - 0.5;

if (_coming_damage == 0) exit;

_coming_damage -= _damage_to_do[0];
_health -= _damage_to_do[7];

if (_health <= 0)
{
    if (_player_train)
        room_goto(rmMap);

    train_destroy();
}

for(var i = 0; i < 15; i++)
{
    _damage_to_do[i] = _damage_to_do[i + 1];
}

_damage_to_do[15] = 0;


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

if (_coupled_backwards != noone)
{
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
}

with (_turrets[0]) turret_step();

with (_turrets[1]) turret_step();

if (_heading_to != noone) exit;

// only engine calculates this...
if (_power == 0) exit;

var tunnel = noone;

if (_curve_pos > _curve._length)
{
    tunnel = train_get_tunnel(_curve._points[_curve._num_points - 1]);
}
else if (_curve_pos < 0)
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

_p = coord_mult(coord_add_2(_back_p, _front_p), 0.5);


#define train_draw
var fx = argument0;
var fy = argument1;

if (_front_p == noone) exit;

var d = coord_subtract(_front_p, _back_p);
var w = coord_mult(coord_rot90(d), _width_ratio / 2);

var c;
c[0] = coord_add_2(_front_p, w);
c[1] = coord_subtract(_front_p, w);
c[2] = coord_add_2(_back_p, w);
c[3] = coord_subtract(_back_p, w);

var tc;

for(var i = 0; i < 4; i++)
{
    tc[i] = grid_transform(fx, fy, c[i], _h, false);
}

var c = train_damage_colour();

draw_set_colour(c);
texture_set_blending(true);

draw_primitive_begin_texture(pr_trianglestrip, sprite_get_texture(sprite_index, 0));
grid_draw_vertex_3(tc[0], 0, 0);
grid_draw_vertex_3(tc[1], 0, 1);
grid_draw_vertex_3(tc[2], 1, 0);
grid_draw_vertex_3(tc[3], 1, 1);
draw_primitive_end();


if (_curve_pos >= 0 && _curve_pos <= _curve._length)
{
    with (_turrets[0]) turret_draw(fx, fy, other._back_p, d, other._h);
    
    with (_turrets[1]) turret_draw(fx, fy, other._back_p, d, other._h);
}


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
var enemy = argument1;

var inst = instance_create(0, 0, obj);

var last = train_find_end();

last._coupled_backwards = inst;
inst._coupled_forwards = last;

_total_weight += inst._weight;

inst._player_train = !enemy;

if (enemy)
{
    inst._colour = merge_colour(c_red, c_dkgray, 0.75);
}

return inst;


#define train_find_end
var inst = self.id;

while(inst._coupled_backwards != noone)
{
    inst = inst._coupled_backwards;
}

return inst;

#define train_destroy
var ob = train_find_start(self.id);

while(ob != noone)
{
    var nob = ob._coupled_backwards;
    with ob instance_destroy();
    ob = nob;
}


#define train_find_start
var inst = argument0;

while(inst._coupled_forwards != noone)
{
    inst = inst._coupled_forwards;
}

return inst;

#define train_damage_colour
var b = 0;

if (_coming_damage > 0)
{
    var l = log2(_coming_damage) + 1;
    
    b = min(l / 3, 1.0);
}

_decay_b = _decay_b * 0.7 + b * 0.3;

return merge_colour(_colour, c_red, _decay_b);
