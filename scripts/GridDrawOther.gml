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

draw_set_color(c_black);

draw_primitive_begin(pr_linestrip);
for(var i = 0; i < crv._num_points; i++)
{
    var pt = grid_transform(fx, fy, crv._points[i]._p, h, false);
    draw_vertex(pt[0], pt[1]);
}
draw_primitive_end();


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

