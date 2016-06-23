#define File

#define file_save
var fname = get_save_filename("*.txt", "PBJ.txt");

if (fname != "")
{
    var f = file_text_open_write(fname);
    
    file_text_write_real(f, global.TilesWidth);
    file_text_write_real(f, global.TilesHeight);
    file_text_writeln(f);
    
    for(var j = 0; j < global.TilesHeight; j++)
    {
        for(var i = 0; i < global.TilesWidth; i++)
        {
            file_text_write_real(f, global.RoomGrid[i, j]);
        }
        
        file_text_writeln(f);
    }
    
    file_text_write_real(f, global.NumPoints);
    file_text_writeln(f);

    for(var i = 0; i < global.NumPoints; i++)
    {
        if (global.Points[i] != noone)
        {
            file_text_write_real(f, 1);
            
            file_text_write_real(f, global.Points[i]._h);
            file_text_write_real(f, global.Points[i]._sc[0]);
            file_text_write_real(f, global.Points[i]._sc[1]);
            file_text_write_real(f, global.Points[i]._p[0]);
            file_text_write_real(f, global.Points[i]._p[1]);
            file_text_write_real(f, global.Points[i]._i);
            file_text_write_real(f, global.Points[i]._j);
        }
        else
        {
            file_text_write_real(f, 0);
        }

        file_text_writeln(f);
    }
    
    file_text_write_real(f, global.NumCurves);
    file_text_writeln(f);

    for(var i = 0; i < global.NumCurves; i++)
    {
        if (global.Curves[i] != noone)
        {
            file_text_write_real(f, 1);
            
            file_text_write_real(f, global.Curves[i]._h);
            file_text_write_real(f, global.Curves[i]._num_points);
            
            for(var j = 0; j < global.Curves[i]._num_points; j++)
            {
                file_text_write_real(f, global.Curves[i]._points[j]._idx);
            }
        }
        else
        {
            file_text_write_real(f, 0);
        }

        file_text_writeln(f);
        
    }
    
    file_text_close(f);
}


#define file_load
var fname = get_open_filename("*.lev", "PBJ.lev");

if (fname != "")
{
    var f = file_text_open_read(fname);
    
    global.TilesWidth = file_text_read_real(f);
    global.TilesHeight = file_text_read_real(f);
    
    for(var j = 0; j < global.TilesHeight; j++)
    {
        for(var i = 0; i < global.TilesWidth; i++)
        {
            global.RoomGrid[i, j] = file_text_read_real(f);
        }
    }
    
    global.NumPoints = file_text_read_real(f);
    
    for(var i = 0; i < global.NumPoints; i++)
    {
        var exists = file_text_read_real(f);
        var inst = noone;

        if (exists)
        {
            inst = instance_create(0, 0, obPoint);
            
            inst._h = file_text_read_real(f);
            inst._sc[0] = file_text_read_real(f);
            inst._sc[1] = file_text_read_real(f);
            inst._p[0] = file_text_read_real(f);
            inst._p[1] = file_text_read_real(f);
            inst._i = file_text_read_real(f);
            inst._j = file_text_read_real(f);
            inst._idx = i;
        }
            
        global.Points[i] = inst;
    }

    global.NumCurves = file_text_read_real(f);

    for(var i = 0; i < global.NumCurves; i++)
    {
        var exists = file_text_read_real(f);
        var inst = noone;

        if (exists)
        {
            inst = instance_create(0, 0, obPoint);
            
            inst._h = file_text_read_real(f);
            inst._num_points = file_text_read_real(f);

            for(var j = 0; j < inst._num_points; j++)
            {
                inst._points[j] = global.Points[file_text_read_real(f)];
            }
            
            inst._idx = i;
        }
            
        global.Curves[i] = inst;
    }
    
    file_text_close(f);
}

grid_make_cubes();

for(var i = 0; i < global.NumPoints; i++)
{
    var pnt = global.Points[i];
    
    if (pnt != noone)
    {
        global.RoomCubes[pnt._i, pnt._j]._points[pnt._sc[0], pnt._sc[1]] = pnt;
    }
}
