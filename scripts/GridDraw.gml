#define GridDraw


#define grid_draw_cubes
var fx = argument0;
var fy = argument1;
var h = argument2;

var square_x = max(min(floor(fx / global.SquareSize), global.TilesWidth - 1), 0);
var square_y = max(min(floor(fy / global.SquareSize), global.TilesHeight - 1), 0);

if (square_y > 0)
{
    if (square_x > 0)
    {
        grid_draw_quadrant(fx, fy,
            square_x, square_y,
            0, 0,
            1, 1,
            h, 0);
    }
    
    if (square_x < global.TilesWidth)
    {
        grid_draw_quadrant(fx, fy,
            square_x - 1, square_y,
            global.TilesWidth - 1, 0,
            -1, 1,
            h, 3);
    }
}

if (square_y < global.TilesWidth)
{
    if (square_x > 0)
    {
        grid_draw_quadrant(fx, fy,
            square_x, square_y - 1,
            0, global.TilesHeight - 1,
            1, -1,
            h, 1);
    }

    if (square_x < global.TilesWidth)
    {
        grid_draw_quadrant(fx, fy,
            square_x - 1, square_y - 1,
            global.TilesWidth - 1, global.TilesHeight - 1,
            -1, -1,
            h, 2);
    }
}


#define grid_draw_quadrant
var fx = argument0;
var fy = argument1;
var esx = argument2;
var esy = argument3;
var ssx = argument4;
var ssy = argument5;
var dsx = argument6;
var dsy = argument7;
var h = argument8;
var d = argument9;

for(var i = ssx; i != esx; i += dsx)
{
    for(var j = ssy; j != esy; j += dsy)
    {
        if (global.RoomCubes[i, j]._h >= h && global.RoomCubes[i, j]._side_min <= h)
        {
            grid_draw_cube(fx, fy, global.RoomCubes[i, j], h, d);
        }
    }
}


#define grid_draw_cube
var fx = argument0;
var fy = argument1;
var cube = argument2;
var h = argument3;
var d = argument4;

texture_set_repeat(true)
texture_set_blending(false);

for(var d = 0; d < 4; d++)
{
    if (cube._side_bottoms[d] < h && cube._h >= h)
    {
        var et1 = grid_transform(fx, fy, cube._p[d], h, true);
        
        var side_rel = coord_subtract(global.ScreenCentre, et1);
        
        var dot = coord_dot(side_rel, cube._side_normals[d]);
        
        // is the centre of the screen outside the side?
        if (dot < 0)
        {
            var dn = (d + 1) % 4;
            
            var et2 = grid_transform(fx, fy, cube._p[dn], h, true);
            var eb1 = grid_transform(fx, fy, cube._p[d], h - 1, true);
            var eb2 = grid_transform(fx, fy, cube._p[dn], h - 1, true);
        
            draw_primitive_begin_texture(pr_trianglestrip, global.CliffTex);
            grid_draw_vertex_2(et1, cube._p[d], 1);
            grid_draw_vertex_2(et2, cube._p[dn], 1);
            grid_draw_vertex_2(eb1, cube._p[d], 0);
            grid_draw_vertex_2(eb2, cube._p[dn], 0);
            draw_primitive_end();
        }
    }
}

if (cube._h == h)
{
    var tp;
    
    for(var i = 0; i < 4; i++)
    {
        tp[i] = grid_transform(fx, fy, cube._p[i], cube._h, true);
    }
    
    draw_primitive_begin_texture(pr_trianglestrip, global.GroundTex[cube._h / 2]);
    grid_draw_vertex(tp[0], cube._p[0]);
    grid_draw_vertex(tp[1], cube._p[1]);
    grid_draw_vertex(tp[3], cube._p[3]);
    grid_draw_vertex(tp[2], cube._p[2]);
    draw_primitive_end();

    if (cube._highlit)
    {
        draw_set_color(cube._highlight_colour);
                
        grid_draw_line(tp[0], tp[1], 3);
        grid_draw_line(tp[1], tp[2], 3);
        grid_draw_line(tp[2], tp[3], 3);
        grid_draw_line(tp[3], tp[0], 3);
    }
    
    if (cube._show_grid)
    {
        draw_set_colour(c_gray);
        
        var a;
        a[ 0] = make_coord((cube._i + 0) * global.SquareSize, (cube._j + 1/6) * global.SquareSize);
        a[ 1] = make_coord((cube._i + 1) * global.SquareSize, (cube._j + 1/6) * global.SquareSize);
        a[ 2] = make_coord((cube._i + 0) * global.SquareSize, (cube._j + 1/2) * global.SquareSize);
        a[ 3] = make_coord((cube._i + 1) * global.SquareSize, (cube._j + 1/2) * global.SquareSize);
        a[ 4] = make_coord((cube._i + 0) * global.SquareSize, (cube._j + 5/6) * global.SquareSize);
        a[ 5] = make_coord((cube._i + 1) * global.SquareSize, (cube._j + 5/6) * global.SquareSize);
        a[ 6] = make_coord((cube._i + 1/6) * global.SquareSize, (cube._j + 0) * global.SquareSize);
        a[ 7] = make_coord((cube._i + 1/6) * global.SquareSize, (cube._j + 1) * global.SquareSize);
        a[ 8] = make_coord((cube._i + 1/2) * global.SquareSize, (cube._j + 0) * global.SquareSize);
        a[ 9] = make_coord((cube._i + 1/2) * global.SquareSize, (cube._j + 1) * global.SquareSize);
        a[10] = make_coord((cube._i + 5/6) * global.SquareSize, (cube._j + 0) * global.SquareSize);
        a[11] = make_coord((cube._i + 5/6) * global.SquareSize, (cube._j + 1) * global.SquareSize);
       
        for(var i = 0; i < 12; i++)
        {
            a[i] = grid_transform(fx, fy, a[i], cube._h, false);
        }
        
        grid_draw_line(a[ 0], a[ 1], 2);
        grid_draw_line(a[ 2], a[ 3], 2);
        grid_draw_line(a[ 4], a[ 5], 2);
        grid_draw_line(a[ 6], a[ 7], 2);
        grid_draw_line(a[ 8], a[ 9], 2);
        grid_draw_line(a[10], a[11], 2);
    }
}



#define grid_transform
var fx = argument0;
var fy = argument1;
var p = argument2;
var h = argument3;
var with_noise = argument4;

// this is set up to go down reciprocally with distance from camera (depth)
// and arranged so that global.GroundHeight is where perspective == 1
var perspective = grid_perspective(h);

var ret;

ret[0] = p[0] - fx;
ret[1] = p[1] - fy;

if (with_noise)
{
    ret[0] += noise(p, 0) * global.NoiseAmount;
    ret[1] += noise(p, 1) * global.NoiseAmount;
}

ret[0] = ret[0] * perspective + global.ScreenCentreX;
ret[1] = ret[1] * perspective + global.ScreenCentreY;

return ret;


#define grid_draw_vertex
var c = argument0;
var t = argument1;

draw_vertex_texture(c[0], c[1], t[0] / global.SquareSize / 4, t[1] / global.SquareSize / 4);


#define grid_draw_vertex_2
var c = argument0;
var t = argument1;
var h = argument2;

// override the y texture coordinate with h
// use diagonal distance on texture x so it changes correctly on x and y of map

draw_vertex_texture(c[0], c[1], (t[0] + t[1]) / global.SquareSize / 4, h);


#define grid_perspective
var h = argument0;

return global.MaxHeights / (global.MaxHeights + global.GroundHeight - h);

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
