#define Tile

#define tile_create_paths
for(var i = 0; i < array_height_2d(_paths_x); i++)
{
    _paths[i] = path_add();
    path_set_kind(_paths[i], 1);
    path_set_closed(_paths[i], false);
    path_set_precision(_paths[i], 8);
    for(var j = 0; j < array_length_2d(_paths_x, i); j++)
    {
        path_add_point(_paths[i],
            _paths_x[i, j] * global.TileSize / 3 - 50,
            _paths_y[i, j] * global.TileSize / 3 - 50, 100);
    }
}

#define tile_draw
var tile = argument0;
var hx = argument1;
var hy = argument2;
var rot = argument3;
var flip = argument4;
var scale = argument5;

with(tile)
{
    for(var i = 0; i < array_length_1d(_paths); i++)
    {
        draw_path_transformed(_paths[i], hx, hy, rot, flip, scale);
    }
}

/* //draw tiles
var a, b, c, d;
a = transform_point(hx, hy, rot, flip, -50, -50);
b = transform_point(hx, hy, rot, flip, -50,  50);
c = transform_point(hx, hy, rot, flip,  50,  50);
d = transform_point(hx, hy, rot, flip,  50, -50);

draw_set_color(c_gray);

draw_line(a[0], a[1], b[0], b[1]);
draw_line(b[0], b[1], c[0], c[1]);
draw_line(c[0], c[1], d[0], d[1]);
draw_line(d[0], d[1], a[0], a[1]);
*/

#define draw_path_transformed
var path = argument0;
var hx = argument1;
var hy = argument2;
var rot = argument3;
var flip = argument4;
var scale = argument5;

draw_primitive_begin(pr_linestrip);

for(var j = 0; j <= 1; j += 0.125)
{
    var new = transformed_path_point(path, hx, hy, rot, flip, j, scale);

    draw_vertex(new[0], new[1]);
}

draw_primitive_end();

#define transformed_path_point
var p = argument0;
var hx = argument1;
var hy = argument2;
var rot = argument3;
var flip = argument4;
var pos = argument5;
var scale = argument6;

var px = path_get_x(p, pos);
var py = path_get_y(p, pos);


return transform_point(hx, hy, rot, flip, px, py, scale);

#define transform_point
var hx = argument0;
var hy = argument1;
var rot = argument2;
var flip = argument3;
var px = argument4;
var py = argument5;
var scale = argument6;

if (flip)
{
    px = -px;
}

var temp;

switch(rot)
{
case 0:
    break;
case 1:
    temp = px; px = -py; py = temp;
    break;
case 2:
    px = -px; py = -py;
    break;
case 3:
    temp = px; px = py; py = -temp;
    break;
}

tx = px * scale + hx;
ty = py * scale + hy;

var ret;
ret[0] = tx;
ret[1] = ty;

return ret;

#define create_all_tiles
enum TileTypes
{
    DoubleCorner,
    Swerve,
    SinglePointsNarrowNear,
    SinglePointsNarrowFar,
    SinglePointsWideNear,
    SinglePointsWideFar,
    Swap,
    Octo,
    Pair,
    PairSinglePointsNear,
    PairSinglePointsFar,
    PairOppositePointsNear,
    PairOppositePointsFar,
    PairOppositePointsNearFar,
    PairOppositePointsFarNear
}

global.all_tiles[TileTypes.DoubleCorner] = instance_create(0, 0, tile_double_corner);
global.all_tiles[TileTypes.Swerve] = instance_create(0, 0, tile_swerve);
global.all_tiles[TileTypes.SinglePointsNarrowNear] = instance_create(0, 0, tile_single_points_narrow_near);
global.all_tiles[TileTypes.SinglePointsNarrowFar] = instance_create(0, 0, tile_single_points_narrow_far);
global.all_tiles[TileTypes.SinglePointsWideNear] = instance_create(0, 0, tile_single_points_wide_near);
global.all_tiles[TileTypes.SinglePointsWideFar] = instance_create(0, 0, tile_single_points_wide_far);
global.all_tiles[TileTypes.Swap] = instance_create(0, 0, tile_swap);
global.all_tiles[TileTypes.Octo] = instance_create(0, 0, tile_octo);
global.all_tiles[TileTypes.Pair] = instance_create(0, 0, tile_pair);
global.all_tiles[TileTypes.PairSinglePointsNear] = instance_create(0, 0, tile_pair_single_points_near);
global.all_tiles[TileTypes.PairSinglePointsFar] = instance_create(0, 0, tile_pair_single_points_far);
global.all_tiles[TileTypes.PairOppositePointsNear] = instance_create(0, 0, tile_pair_opposite_points_near);
global.all_tiles[TileTypes.PairOppositePointsFar] = instance_create(0, 0, tile_pair_opposite_points_far);
global.all_tiles[TileTypes.PairOppositePointsNearFar] = instance_create(0, 0, tile_pair_opposite_points_near_far);
global.all_tiles[TileTypes.PairOppositePointsFarNear] = instance_create(0, 0, tile_pair_opposite_points_far_near);

