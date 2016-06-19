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
        grid_make_cube(i, j, global.RoomGrid[i, j]);
    }
}


#define grid_make_cube
var i = argument0;
var j = argument1;
var h = argument2;

var x_l = i * global.SquareSize;
var x_h = i * global.SquareSize + global.SquareSize;
var y_l = j * global.SquareSize;
var y_h = j * global.SquareSize + global.SquareSize;

var inst = instance_create(x_l, y_l, obCube);

inst._p[0, 0] = x_l; inst._p[0, 1] = y_h;
inst._p[1, 0] = x_h; inst._p[1, 1] = y_h;
inst._p[2, 0] = x_h; inst._p[2, 1] = y_l;
inst._p[3, 0] = x_l; inst._p[3, 1] = y_l;

inst._h = h;

grid_make_sides(i, j, h, inst);

global.RoomCubes[i, j] = inst;

#define grid_make_sides
var i = argument0;
var j = argument1;
var h = argument2;
var cube = argument3;

var x_c = (i + 0.5) * global.SquareSize;
var y_c = (j + 0.5) * global.SquareSize;

for(var d = 0; d < 4; d++)
{
    var ni = i + global.OrthDirs[d, 0];
    var nj = j + global.OrthDirs[d, 1];
    
    if (ni >= 0 && ni < global.TilesWidth &&
        nj >= 0 && nj < global.TilesHeight)
    {
        var other_h = global.RoomGrid[ni, nj];
        var p_d = (d + 1) % 4;
        var m_d = (d + 3) % 4;
        
        if (other_h < h)
        {
            cube._side_tops[d] = h;
            cube._side_bottoms[d] = other_h;
        }
    }
}

