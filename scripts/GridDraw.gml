#define GridDraw


#define grid_draw_squares
var fx = argument0;
var fy = argument1;

for(j = 0; j < global.MaxHeights; j++)
{
    for (var i = 0; i < ds_list_size(global.RoomSquares[j]); i++)
    {
        grid_draw_square(fx, fy, ds_list_find_value(global.RoomSquares[j], i));
    }
}

#define grid_draw_sides
var fx = argument0;
var fy = argument1;

for(j = 0; j < global.MaxHeights; j++)
{
    for (var i = 0; i < ds_list_size(global.RoomSides[j]); i++)
    {
        grid_draw_side(fx, fy, ds_list_find_value(global.RoomSides[j], i));
    }
}

#define grid_draw_square
var fx = argument0;
var fy = argument1;
var sq = argument2;

var bl = grid_transform(fx, fy, sq._bl, sq._height);
var br = grid_transform(fx, fy, sq._br, sq._height);
var tl = grid_transform(fx, fy, sq._tl, sq._height);
var tr = grid_transform(fx, fy, sq._tr, sq._height);

texture_set_repeat(true)
texture_set_blending(false);

draw_primitive_begin_texture(pr_trianglestrip, global.GroundTex[sq._height]);
draw_vertex_texture(bl[0], bl[1],
    sq._bl[0] / global.SquareSize / 4, sq._bl[1] / global.SquareSize / 4);
draw_vertex_texture(br[0], br[1],
    sq._br[0] / global.SquareSize / 4, sq._br[1] / global.SquareSize / 4);
draw_vertex_texture(tl[0], tl[1], sq._tl[0] / global.SquareSize / 4,
    sq._tl[1] / global.SquareSize / 4);
draw_vertex_texture(tr[0], tr[1],
    sq._tr[0] / global.SquareSize / 4, sq._tr[1] / global.SquareSize / 4);
draw_primitive_end();


#define grid_transform
var fx = argument0;
var fy = argument1;
var c = argument2;
var h = argument3;

// this is set up to go down reciprocally with distance from camera (depth)
// and arranged so that global.GroundHeight is where perspective == 1
var perspective = global.MaxHeights / (global.MaxHeights + global.GroundHeight - h);

var ret;
ret[0] = (c[0] - fx) * perspective + global.ScreenCentreX;
ret[1] = (c[1] - fy) * perspective + global.ScreenCentreY;

return ret;


#define grid_draw_side
var fx = argument0;
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

