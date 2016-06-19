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
        if (global.RoomCubes[i, j]._h == h)
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

var tp;

for(var i = 0; i < 4; i++)
{
    tp[i] = grid_transform(fx, fy, cube._p[i], cube._h);
}

texture_set_repeat(true)
texture_set_blending(false);

var dn = (d + 1) % 4;

if (cube._side_bottoms[d] != -1)
{
    var et1 = tp[d];
    var et2 = tp[dn];
    var eb1 = grid_transform(fx, fy, cube._p[d], cube._side_bottoms[d]);    
    var eb2 = grid_transform(fx, fy, cube._p[dn], cube._side_bottoms[d]);    

    draw_primitive_begin_texture(pr_trianglestrip, global.CliffTex);
    grid_draw_vertex_2(et1, cube._p[d], 1);
    grid_draw_vertex_2(et2, cube._p[dn], 1);
    grid_draw_vertex_2(eb1, cube._p[d], 0);
    grid_draw_vertex_2(eb2, cube._p[dn], 0);
    draw_primitive_end();
}

d = dn;
dn = (d + 1) % 4;

if (cube._side_bottoms[d] != -1)
{
    var et1 = tp[d];
    var et2 = tp[dn];
    var eb1 = grid_transform(fx, fy, cube._p[d], cube._side_bottoms[d]);    
    var eb2 = grid_transform(fx, fy, cube._p[dn], cube._side_bottoms[d]);    

    draw_primitive_begin_texture(pr_trianglestrip, global.CliffTex);
    grid_draw_vertex_2(et1, cube._p[d], 1);
    grid_draw_vertex_2(et2, cube._p[dn], 1);
    grid_draw_vertex_2(eb1, cube._p[d], 0);
    grid_draw_vertex_2(eb2, cube._p[dn], 0);
    draw_primitive_end();
    
}

draw_primitive_begin_texture(pr_trianglestrip, global.GroundTex[cube._h]);
grid_draw_vertex(tp[0], cube._p[0]);
grid_draw_vertex(tp[1], cube._p[1]);
grid_draw_vertex(tp[3], cube._p[3]);
grid_draw_vertex(tp[2], cube._p[2]);
draw_primitive_end();


#define grid_transform
var fx = argument0;
var fy = argument1;
var p = argument2;
var h = argument3;

// this is set up to go down reciprocally with distance from camera (depth)
// and arranged so that global.GroundHeight is where perspective == 1
var perspective = global.MaxHeights / (global.MaxHeights + global.GroundHeight - h);

var ret;

ret[0] = (p[0] - fx) * perspective + global.ScreenCentreX;
ret[1] = (p[1] - fy) * perspective + global.ScreenCentreY;

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

