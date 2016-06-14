#define Tile

#define tile_draw
var hx = argument0;
var hy = argument1;
var rot = argument2;
var flip = argument3;

for(var i = 0; i < array_length_1d(_paths); i++)
{
    draw_path_transformed(_paths[i], hx, hy, rot, flip);
}

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
            _paths_x[i, j] * 100 / 3 - 50,
            _paths_y[i, j] * 100 / 3 - 50, 100);
    }
}

#define draw_path_transformed
var path = argument0;
var hx = argument1;
var hy = argument2;
var rot = argument3;
var flip = argument4;

var cur = noone;

for(var j = 0; j <= 1; j += 0.1)
{
    var new = transformed_path_point(path, hx, hy, rot, flip, j);

    if (cur != noone)
    {
        draw_line(cur[0], cur[1], new[0], new[1]);
    }
    
    cur = new;
}


#define transformed_path_point
var p = argument0;
var hx = argument1;
var hy = argument2;
var rot = argument3;
var flip = argument4;
var pos = argument5;

var px = path_get_x(p, pos);
var py = path_get_y(p, pos);

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

tx = px + hx;
ty = py + hy;

var ret;
ret[0] = tx * 2 / 3 - ty * 2 / 3;
ret[1] = tx * 1 / 3 + ty * 1 / 3;

return ret;
#define create_all_tiles
enum TileTypes
{
    DoubleCorner,
    Swerve,
    SinglePointsNarrowNear,
    SinglePointsNarrowFar,
    SinglePointsWideNear,
    SinglePointsWideFar
}

global.all_tiles[TileTypes.DoubleCorner] = instance_create(0, 0, tile_double_corner);
global.all_tiles[TileTypes.Swerve] = instance_create(0, 0, tile_swerve);
global.all_tiles[TileTypes.SinglePointsNarrowNear] = instance_create(0, 0, tile_single_points_narrow_near);
global.all_tiles[TileTypes.SinglePointsNarrowFar] = instance_create(0, 0, tile_single_points_narrow_far);
global.all_tiles[TileTypes.SinglePointsWideNear] = instance_create(0, 0, tile_single_points_wide_near);
global.all_tiles[TileTypes.SinglePointsWideFar] = instance_create(0, 0, tile_single_points_wide_far);

