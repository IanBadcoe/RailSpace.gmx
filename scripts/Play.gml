#define Play

#define play_load_level
var fname = working_directory + global._level_file;

file_load(fname);
#define play_level_setup
global.PlayerTrain = train_create_player_train();

for(var i = 0; i < global.NumTunnels; i++)
{
    if (global.Tunnels[i] != noone && string_pos("ps", global.Tunnels[i]._labels))
    {
        var cube = global.Tunnels[i]._cube;
        var curve_data = find_first_curve(cube);
        
        if (curve_data != noone)
        {     
            train_follow_curve(global.PlayerTrain, curve_data[0], curve_data[1], 3);
        }
    }
}

