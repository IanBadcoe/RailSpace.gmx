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

draw_primitive_begin_texture(pr_trianglestrip, sprite_get_texture(sprite_index, image_index));
grid_draw_vertex_3(tc[0], 0, 0);
grid_draw_vertex_3(tc[1], 0, 1);
grid_draw_vertex_3(tc[3], 1, 0);
grid_draw_vertex_3(tc[2], 1, 1);
draw_primitive_end();


#define turret_step
// before we know where we are...
if _p[0] == 0 && _p[1] == 0 exit;

if (_enemy_turret)
{
    if (global.PlayerTrain == noone) exit;

    var dx = global.PlayerTrain._p[0] - _p[0];
    var dy = global.PlayerTrain._p[1] - _p[1];
    
    _angle = arctan2(dx, dy);
    
    var d = sqrt(dx * dx + dy * dy);
    
    // stutter firing a bit...
    if (d < _range && _fire_cycle == -1 && random(1) < 0.1)
    {
        _fire_cycle = 0;
        
        turret_create_missile(_missile_type, _p, global.PlayerTrain._p, global.PlayerTrain, _wagon._h);
    }
}
else
{
    var m;
    
    m[0] = window_mouse_get_x();
    m[1] = window_mouse_get_y();
    
    var dx = m[0] - _p[0];
    var dy = m[1] - _p[1];
    
    _angle = arctan2(dx, dy);

    var d = sqrt(dx * dx + dy * dy);
    
    if (d < _range && _fire_cycle == -1 && mouse_button = mb_left)
    {
        var targ = turret_find_target(m);
        if (targ != noone)
        {
            turret_create_missile(_missile_type, _p, targ._p, targ, _wagon._h);        
        }
        else
        {
            var pt = grid_untransform(global._focus_x, global._focus_y, m, _wagon._h);
            
            turret_create_missile(_missile_type, _p, pt, noone, _wagon._h);        
        }
        
        _fire_cycle = 0;
    }
}

image_index = 0;

if (_fire_cycle != -1)
{
    _fire_cycle++;
        
    if (_fire_cycle < _recoil_time)
    {
        image_index = 1;
    }
    
    if _fire_cycle == _cycle_length
        _fire_cycle = -1;
}


#define turret_create_missile
var ob = argument0;
var orig = argument1;
var targ_pos = argument2;
var targ = argument3;
var h = argument4;

var inst = instance_create(0, 0, ob);
inst._targ_pos = targ_pos;
inst._origin = orig;
inst._target = targ;
inst._h = h;

// missiles use these
inst._p = coord_copy(orig);
inst._angle = _angle;
inst._v[0] = sin(_angle) * 10;
inst._v[1] = cos(_angle) * 10;


#define turret_find_target
var p = argument0;

with(obRollingStock)
{
    if (_enemy)
    {
        var pt = grid_untransform(global._focus_x, global._focus_y, p, _h);
        
        var dist = coord_dist(pt, _p);
        
        if (dist < 15)
        {
            return self.id;
        }
    }
}

return noone;
