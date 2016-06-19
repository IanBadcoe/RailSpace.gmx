#define GridDraw


#define grid_draw_cubes
var fx = argument0;
var fy = argument1;
var h = argument2;

var square_x = floor(fx / global.SquareSize);
var square_y = floor(fy / global.SquareSize);

if (square_y > 0)
{
    if (square_x > 0)
    {
        grid_draw_quadrant(fx, fy,
            square_x, square_y,
            0, 0,
            1, 1,
            h, 1);
    }
    
    if (square_x < global.TilesWidth)
    {
        grid_draw_quadrant(fx, fy,
            square_x - 1, square_y,
            global.TilesWidth - 1, 0,
            -1, 1,
            h, 2);
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
            h, 0);
    }

    if (square_x < global.TilesWidth)
    {
        grid_draw_quadrant(fx, fy,
            square_x - 1, square_y - 1,
            global.TilesWidth - 1, global.TilesHeight - 1,
            -1, -1,
            h, 3);
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
            grid_draw_cube(fx, fy, global.RoomCubes[i, j]);
        }
    }
}


#define grid_draw_cube
var fx = argument0;
var fy = argument1;
var cube = argument2;

var fx = argument0;
var fy = argument1;
var sq = argument2;

var tp;

for(var i = 0; i < 4; i++)
{
    tp[i] = grid_transform(fx, fy, cube._p[i, 0], cube._p[i, 1], cube._h);
}

texture_set_repeat(true)
texture_set_blending(false);

draw_primitive_begin_texture(pr_trianglestrip, global.GroundTex[cube._h]);
grid_draw_vertex(tp[0], cube._p[0, 0], cube._p[0, 1]);
grid_draw_vertex(tp[1], cube._p[1, 0], cube._p[1, 1]);
grid_draw_vertex(tp[3], cube._p[3, 0], cube._p[3, 1]);
grid_draw_vertex(tp[2], cube._p[2, 0], cube._p[2, 1]);
draw_primitive_end();


#define grid_transform
var fx = argument0;
var fy = argument1;
var px = argument2;
var py = argument3;
var h = argument4;

// this is set up to go down reciprocally with distance from camera (depth)
// and arranged so that global.GroundHeight is where perspective == 1
var perspective = global.MaxHeights / (global.MaxHeights + global.GroundHeight - h);

var ret;

ret[0] = (px - fx) * perspective + global.ScreenCentreX;
ret[1] = (py - fy) * perspective + global.ScreenCentreY;

return ret;


#define grid_draw_side
/*var fx = argument0;
var fy = argument1;
var sq = argument2;

var t1 = grid_transform(fx, fy, sq._p1, sq._h_up);
var t2 = grid_transform(fx, fy, sq._p2, sq._h_up);
var b1 = grid_transform(fx, fy, sq._p1, sq._h_down);
var b2 = grid_transform(fx, fy, sq._p2, sq._h_down);

texture_set_repeat(true)
texture_set_blending(false);

draw_primitive_begin_texture(pr_trianglestrip, global.CliffTex);
draw_vertex_texture(t1[0], t1[1],
    (sq._p1[0] + sq._p1[1]) / global.SquareSize / 4, 1);
draw_vertex_texture(t2[0], t2[1],
    (sq._p2[0] + sq._p2[1]) / global.SquareSize / 4, 1);
draw_vertex_texture(b1[0], b1[1],
    (sq._p1[0] + sq._p1[1]) / global.SquareSize / 4, 0);
draw_vertex_texture(b2[0], b2[1],
    (sq._p2[0] + sq._p2[1]) / global.SquareSize / 4, 0);
draw_primitive_end();
*/

#define grid_draw_vertex
var c = argument0;
var tx = argument1;
var ty = argument2;

draw_vertex_texture(c[0], c[1], tx / global.SquareSize / 4, ty / global.SquareSize / 4);

