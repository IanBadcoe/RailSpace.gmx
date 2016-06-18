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
grid_make_squares();
grid_make_sides();

#define grid_make_sides
if (global.RoomSides != noone)
{
    for(i = 0; i < global.MaxHeights; i++)
    {
        ds_list_destroy(global.RoomSides[i]);
    }
}

for(i = 0; i < global.MaxHeights; i++)
{
    global.RoomSides[i] = ds_list_create();
}

for(var i = 0; i < global.TilesWidth; i++)
{
    for(var j = 0; j < global.TilesHeight; j++)
    {
        grid_make_side(i, j, global.RoomGrid[i, j]);
    }
}


#define grid_make_side
var i = argument0;
var j = argument1;
var h = argument2;

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
            var x1 = x_c + (global.OrthDirs[d, 0] + global.OrthDirs[p_d, 0]) * global.SquareSize * 0.5;
            var y1 = y_c + (global.OrthDirs[d, 1] + global.OrthDirs[p_d, 1]) * global.SquareSize * 0.5;
            var x2 = x_c + (global.OrthDirs[d, 0] + global.OrthDirs[m_d, 0]) * global.SquareSize * 0.5;
            var y2 = y_c + (global.OrthDirs[d, 1] + global.OrthDirs[m_d, 1]) * global.SquareSize * 0.5;

            var inst = instance_create(x_c, y_c, obSide);

            inst._p1[0] = x1; inst._p1[1] = y1;
            inst._p2[0] = x2; inst._p2[1] = y2;
            inst._h_up = h;
            inst._h_down = other_h;

            ds_list_add(global.RoomSides[h], inst);
        }
    }
}


#define grid_make_squares
if (global.RoomSquares != noone)
{
    for(i = 0; i < global.MaxHeights; i++)
    {
        ds_list_destroy(global.RoomSquares[i]);
    }
}

for(i = 0; i < global.MaxHeights; i++)
{
    global.RoomSquares[i] = ds_list_create();
}

for(var i = 0; i < global.TilesWidth; i++)
{
    for(var j = 0; j < global.TilesHeight; j++)
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

ds_list_add(global.RoomSquares[h], inst);

