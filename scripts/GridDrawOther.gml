#define GridDrawOther


#define grid_draw_line
var p1 = argument0;
var p2 = argument1;
var w = argument2;

draw_line_width(p1[0], p1[1], p2[0], p2[1], w);
#define grid_draw_points
var fx = argument0;
var fy = argument1;
var h = argument2;

for(var i = 0; i < global.NumPoints; i++)
{
    if (global.Points[i] != noone && global.Points[i]._h = h)
    {
        grid_draw_point(fx, fy, global.Points[i]);
    }
}

#define grid_draw_point
var fx = argument0;
var fy = argument1;
var pnt = argument2;

var p = pnt._p;
var h = pnt._h;

var t = grid_transform(fx, fy, p, h, false);

if (global._selected_points[0] == pnt)
{
    draw_set_colour(c_yellow);
}
else if (edit_point_is_selected(pnt))
{
    draw_set_colour(c_white);
}
else
{
    draw_set_colour(c_blue);
}

draw_circle(t[0], t[1], 3, false);


#define grid_draw_curves
var fx = argument0;
var fy = argument1;
var h = argument2;

for(var i = 0; i < global.NumCurves; i++)
{
    if (global.Curves[i] != noone && global.Curves[i]._h = h)
    {
        grid_draw_curve(fx, fy, global.Curves[i]);
    }
}

#define grid_draw_curve
var fx = argument0;
var fy = argument1;
var crv = argument2;

var h = crv._h;
var step = 8 / crv._length;

draw_set_color(c_black);

draw_primitive_begin(pr_linestrip);
for(var i = 0; i <= 1; i += step)
{
    var p;
    p[0] = path_get_x(crv._path, i);
    p[1] = path_get_y(crv._path, i);
    
    var pt = grid_transform(fx, fy, p, h, false);
    draw_vertex(pt[0], pt[1]);
}
draw_primitive_end();

step = 42 / crv._length;

var q = noone;
var prev = false;

for(var i = 0; i <= 1; i += step)
{
    var p;
    p[0] = path_get_x(crv._path, i);
    p[1] = path_get_y(crv._path, i);
    
    if (q != noone)
    {
        var ch = global.RoomGrid[p[0] / global.SquareSize, p[1] / global.SquareSize];

        var cur = ch < h;

        if (cur || prev)
        {
            grid_draw_bridge(p, q, h, fx, fy);
        }
        
        prev = cur;
    }
    
    q = coord_copy(p);
}


#define grid_draw_tunnels
var fx = argument0;
var fy = argument1;
var h = argument2;

for(var i = 0; i < global.NumTunnels; i++)
{
    if (global.Tunnels[i] != noone && global.Tunnels[i]._h = h)
    {
        grid_draw_tunnel(fx, fy, global.Tunnels[i]);
    }
}

#define grid_draw_tunnel
var fx = argument0;
var fy = argument1;
var tnl = argument2;

if (!global.ShowTunnels) exit;

var h = tnl._h;

var s = global.SquareSize * 0.45;

var bs;

bs[0] = coord_add(tnl._p,  s,  s);
bs[1] = coord_add(tnl._p,  s, -s);
bs[2] = coord_add(tnl._p, -s, -s);
bs[3] = coord_add(tnl._p, -s,  s);

s *= 0.8;

var ts;

ts[0] = coord_add(tnl._p,  s,  s);
ts[1] = coord_add(tnl._p,  s, -s);
ts[2] = coord_add(tnl._p, -s, -s);
ts[3] = coord_add(tnl._p, -s,  s);

for(var i = 0; i < 4; i++)
{
    tst[i] = grid_transform(fx, fy, ts[i], h + 0.8, true);
    bst[i] = grid_transform(fx, fy, bs[i], h, true);
}

for(var i = 0; i < 4; i++)
{
    var ip = (i + 1) % 4;
    
    draw_primitive_begin_texture(pr_trianglestrip, global.TunnelTex);
    grid_draw_vertex_3(tst[i], 0, 0);
    grid_draw_vertex_3(tst[ip], 1, 0);
    grid_draw_vertex_3(bst[i], 0, 1);
    grid_draw_vertex_3(bst[ip], 1, 1);
    draw_primitive_end();
}

draw_primitive_begin_texture(pr_trianglestrip, global.GroundTex[h]);
grid_draw_vertex(tst[0], ts[0]);
grid_draw_vertex(tst[1], ts[1]);
grid_draw_vertex(tst[3], ts[3]);
grid_draw_vertex(tst[2], ts[2]);
draw_primitive_end();

if global.TunnelLabels
{
    draw_set_colour(c_white);
    draw_set_font(fntDebug);
    var c = coord_mult(coord_add_2(tst[0], tst[2]), 0.5);
    var s = string(tnl._idx);
    
    if (tnl._to != -1)
    {
        s += "-(" + string(tnl._time) + ")->" + string(tnl._to);
    }
    draw_text(c[0], c[1], s);
}


#define grid_draw_bridge
var p = argument0;
var q = argument1;
var h = argument2;
var fx = argument3;
var fy = argument4;

var d = coord_subtract(p, q);
var w = coord_rot90(coord_mult(d, 42 / 26 / 2));

var c;
c[0] = coord_add_2(p, w);
c[1] = coord_subtract(p, w);
c[2] = coord_add_2(q, w);
c[3] = coord_subtract(q, w);

var tc;

for(var i = 0; i < 4; i++)
{
    tc[i] = grid_transform(fx, fy, c[i], h, false);
}

draw_primitive_begin_texture(pr_trianglestrip, sprite_get_texture(sprBridge, 0));
grid_draw_vertex_3(tc[0], 0, 0);
grid_draw_vertex_3(tc[1], 1, 0);
grid_draw_vertex_3(tc[2], 0, 1);
grid_draw_vertex_3(tc[3], 1, 1);
draw_primitive_end();