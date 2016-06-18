#define Grid

#define grid_make_grid
var str = argument0;

// size the array
global.RoomGrid[15, 15] = 0;

for(var i = 0; i < 16; i++)
{
    for(var j = 0; j < 16; j++)
    {
        var o = string_ord_at(str, (j * 16 + i) * 2 + 1);
        
        global.RoomGrid[i, j] = real(chr(o));
    }
}


#define grid_make_level
var str = argument0;

grid_make_grid(str);
grid_make_squares();
grid_make_sides();

#define grid_make_sides

#define grid_make_squares
if (global.RoomSquares != noone)
{
    ds_list_destroy(global.RoomSquares);
}

global.RoomSquares = ds_list_create();

for(var i = 0; i < 16; i++)
{
    for(var j = 0; j < 16; j++)
    {
        grid_make_square(i, j, global.RoomGrid[i, j]);
    }
}


#define grid_make_square
var i = argument0;
var j = argument1;
var h = argument2;

var x_l = i * global.SquareSize;
var x_h = i * global.SquareSize + global.SquareSize;
var y_l = j * global.SquareSize;
var y_h = j * global.SquareSize + global.SquareSize;

var inst = instance_create(x_l, y_l, obSquare);

inst._bl[0] = x_l; inst._bl[1] = y_l;
inst._br[0] = x_h; inst._br[1] = y_l;
inst._tl[0] = x_l; inst._tl[1] = y_h;
inst._tr[0] = x_h; inst._tr[1] = y_h;

inst._height = h;

ds_list_add(global.RoomSquares, inst);


#define grid_draw_squares
var fx = argument0;
var fy = argument1;

for (var i = 0; i < ds_list_size(global.RoomSquares); i++)
{
    grid_draw_square(fx, fy, ds_list_find_value(global.RoomSquares, i));
}


#define grid_draw_sides
var fx = argument0;
var fy = argument1;



#define grid_draw_square
var fx = argument0;
var fy = argument1;
var sq = argument2;

var bl = grid_transform(fx, fy, sq._bl, sq._height);
var br = grid_transform(fx, fy, sq._br, sq._height);
var tl = grid_transform(fx, fy, sq._tl, sq._height);
var tr = grid_transform(fx, fy, sq._tr, sq._height);

/*draw_text(100, 100, string(bl[0]) + ", " + string(bl[1]) + ", " + string(sq._height));
draw_text(100, 120, string(br[0]) + ", " + string(br[1]) + ", " + string(sq._height));
draw_text(100, 140, string(tl[0]) + ", " + string(tl[1]) + ", " + string(sq._height));
draw_text(100, 160, string(tr[0]) + ", " + string(tr[1]) + ", " + string(sq._height)); */

//draw_set_colour(c_red);

/*
draw_primitive_begin(pr_trianglestrip);
draw_vertex_colour(bl[0], bl[1], c_blue, 1 - sq._height / 5);
draw_vertex_colour(br[0], br[1], c_blue, 1 - sq._height / 5);
draw_vertex_colour(tl[0], tl[1], c_blue, 1 - sq._height / 5);
draw_vertex_colour(tr[0], tr[1], c_blue, 1 - sq._height / 5);
draw_primitive_end();
*/

texture_set_repeat(true)
texture_set_blending(true);

draw_primitive_begin_texture(pr_trianglestrip, background_get_texture(txtGround));
draw_vertex_texture_colour(bl[0], bl[1],
    sq._bl[0] / global.SquareSize / 4, sq._bl[1] / global.SquareSize / 4,
    c_blue, 1 - sq._height / 5);
draw_vertex_texture_colour(br[0], br[1],
    sq._br[0] / global.SquareSize / 4, sq._br[1] / global.SquareSize / 4,
    c_blue, 1 - sq._height / 5);
draw_vertex_texture_colour(tl[0], tl[1], sq._tl[0] / global.SquareSize / 4,
    sq._tl[1] / global.SquareSize / 4,
    c_blue, 1 - sq._height / 5);
draw_vertex_texture_colour(tr[0], tr[1],
    sq._tr[0] / global.SquareSize / 4, sq._tr[1] / global.SquareSize / 4,
    c_blue, 1 - sq._height / 5);
draw_primitive_end();

/*draw_primitive_begin_texture(pr_trianglestrip, background_get_texture(txtGround));
draw_vertex_texture(bl[0], bl[1], 0, 0);
draw_vertex_texture(br[0], br[1], 0, 1);
draw_vertex_texture(tl[0], tl[1], 1, 0);
draw_vertex_texture(tr[0], tr[1], 1, 1);
draw_primitive_end(); */


#define grid_transform
var fx = argument0;
var fy = argument1;
var c = argument2;
var h = argument3;

var ret;
ret[0] = (c[0] - fx) * 5 / (7 - h) + global.ScreenCentreX;
ret[1] = (c[1] - fy) * 5 / (7 - h) + global.ScreenCentreY;

return ret;

