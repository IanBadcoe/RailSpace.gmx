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

#define edit_tunnel_labels
var cube = argument0;
var tnl = cube._tunnel;

edit_request_string("Tunnel labels, no spaces, comma separated:", tnl._labels);
// need this to know where to store the string
_current_tunnel = tnl;
_tunnel_edit_phase = 0;

#define edit_tunnel_name
var tnl = argument0;

edit_request_string("Tunnel name:", tnl._name);
// need this to know where to store the string
_current_tunnel = tnl;
_tunnel_edit_phase = 1;

#define edit_tunnel_time
var tnl = argument0;

edit_request_string("Tunnel time:", string(tnl._time));
// need this to know where to store the string
_current_tunnel = tnl;
_tunnel_edit_phase = 2;

#define edit_tunnel_to
var tnl = argument0;

edit_request_string("Tunnel to:", tnl._to);
// need this to know where to store the string
_current_tunnel = tnl;
_tunnel_edit_phase = 3;