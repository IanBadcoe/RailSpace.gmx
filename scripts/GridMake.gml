#define GridMake


#define grid_make_grid
var str = argument0;

// size the array
global.RoomGrid[15, 15] = 0;

for(var i = 0; i < global.TilesWidth; i++)
{
    for(var j = 0; j < global.TilesHeight; j++)
    {
        var o = string_ord_at(str, (j * global.TilesWidth + i) * 2 + 1);
        
        global.RoomGrid[i, j] = real(chr(o));
    }
}


#define grid_make_level
var str = argument0;

grid_make_grid(str);
grid_make_cubes();


#define grid_make_cubes
for(var i = 0; i < global.TilesWidth; i++)
{
    for(var j = 0; j < global.TilesHeight; j++)
    {
        grid_make_cube(i, j);
    }
}


#define grid_make_cube
var i = argument0;
var j = argument1;

var h = global.RoomGrid[i, j];

var x_l = i * global.SquareSize;
var x_h = i * global.SquareSize + global.SquareSize;
var y_l = j * global.SquareSize;
var y_h = j * global.SquareSize + global.SquareSize;

var inst = instance_create(x_l, y_l, obCube);

inst._p[0] = make_coord(x_l, y_h);
inst._p[1] = make_coord(x_h, y_h);
inst._p[2] = make_coord(x_h, y_l);
inst._p[3] = make_coord(x_l, y_l);

inst._i = i;
inst._j = j;

inst._h = h;

grid_make_sides(i, j, h, inst);

global.RoomCubes[i, j] = inst;

#define grid_make_sides
var i = argument0;
var j = argument1;
var h = argument2;
var cube = argument3;


var tp;

for(var d = 0; d < 4; d++)
{
    tp[d] = grid_transform(0, 0, cube._p[d], cube._h);
}

for(var d = 0; d < 4; d++)
{
    var ni = i + global.OrthDirs[d, 0];
    var nj = j + global.OrthDirs[d, 1];
    
    if (ni >= 0 && ni < global.TilesWidth &&
        nj >= 0 && nj < global.TilesHeight)
    {
        var other_h = global.RoomGrid[ni, nj];
        
        if (other_h < h)
        {
            cube._side_bottoms[d] = other_h;

            var dn = (d + 1) % 4;
            cube._side_normals[d] = coord_normalised(coord_rot90(coord_subtract(tp[dn], tp[d])));
        }
    }
}

