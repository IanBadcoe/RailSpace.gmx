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
    
    file_text_write_real(f, global.NumTunnels);
    file_text_writeln(f);

    for(var i = 0; i < global.NumTunnels; i++)
    {
        if (global.Tunnels[i] != noone)
        {
            file_text_write_real(f, 5);
            
            file_text_write_real(f, global.Tunnels[i]._h);
            file_text_write_real(f, global.Tunnels[i]._i);
            file_text_write_real(f, global.Tunnels[i]._j);
            file_text_write_real(f, global.Tunnels[i]._p[0]);
            file_text_write_real(f, global.Tunnels[i]._p[1]);

            file_text_write_real(f, global.Tunnels[i]._to);
            file_text_write_real(f, global.Tunnels[i]._time);
            file_text_write_real(f, global.Tunnels[i]._player_start);

            file_text_write_real(f, global.Tunnels[i]._enemy_type);
            file_text_write_real(f, global.Tunnels[i]._enemy_delay);
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
var fname = argument0

if (fname == "")
{
    fname = get_open_filename("*.lev", "PBJ.lev");
}

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
            inst = instance_create(0, 0, obCurve);
            
            inst._h = file_text_read_real(f);
            inst._num_points = file_text_read_real(f);

            for(var j = 0; j < inst._num_points; j++)
            {
                var pnt = global.Points[file_text_read_real(f)];
                inst._points[j] = pnt;
                pnt._curve = inst;
            }
            
            inst._idx = i;

            with inst edit_curve_recalc();
        }
            
        global.Curves[i] = inst;
    }
    
    global.NumTunnels = file_text_read_real(f);
    
    for(var i = 0; i < global.NumTunnels; i++)
    {
        var exists = file_text_read_real(f);
        var inst = noone;

        if (exists)
        {
            inst = instance_create(0, 0, obTunnel);
            
            inst._h = file_text_read_real(f);
            inst._i = file_text_read_real(f);
            inst._j = file_text_read_real(f);
            inst._p[0] = file_text_read_real(f);
            inst._p[1] = file_text_read_real(f);
            inst._to = file_text_read_real(f);
            inst._time = file_text_read_real(f);
            
            inst._idx = i;
        }
        
        if (exists > 3)
        {
            inst._player_start = file_text_read_real(f);
        }
            
        if (exists > 4)
        {
            inst._enemy_type = file_text_read_real(f);
            inst._enemy_delay = file_text_read_real(f);
        }

        global.Tunnels[i] = inst;
    }

    file_text_close(f);
}

grid_make_cubes();

for(var i = 0; i < global.NumPoints; i++)
{
    var pnt = global.Points[i];
    
    if (pnt != noone)
    {
        var cube = global.RoomCubes[pnt._i, pnt._j];
        cube._points[pnt._sc[0], pnt._sc[1]] = pnt;
        pnt._cube = cube;
    }
}

for(var i = 0; i < global.NumTunnels; i++)
{
    var tnl = global.Tunnels[i];
    
    if (tnl != noone)
    {
        var cube = global.RoomCubes[tnl._i, tnl._j];
        cube._tunnel = tnl;
        tnl._cube = cube;
    }
}