#define EditTunnel

#define edit_add_tunnel
var cube = argument0;

var inst = instance_create(0, 0, obTunnel);
inst._cube = cube;
inst._h = cube._h;
inst._i = cube._i;
inst._j = cube._j;
inst._p = coord_add(cube._p[3], global.SquareSize * 0.5, global.SquareSize * 0.5);

cube._tunnel = inst;

global.Tunnels[global.NumTunnels] = inst;
inst._idx = global.NumTunnels;
global.NumTunnels++;


#define edit_remove_tunnel
var cube = argument0;

var tnl = cube._tunnel;

if (tnl == noone) exit;

cube._tunnel = noone;
tnl._cube = noone;

global.Tunnels[tnl._idx] = noone;

with (tnl) instance_destroy();