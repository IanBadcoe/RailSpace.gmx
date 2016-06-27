#define Play

#define play_load_level
var fname = working_directory + global._level_file;

file_load(fname);
#define play_level_setup
global.PlayerTrain = train_create_player_train();

play_map_tunnels();

for(var i = 0; i < global.NumTunnels; i++)
{
    if (global.Tunnels[i] != noone && string_pos("ps", global.Tunnels[i]._labels))
    {
        train_follow_track_from_tunnel(global.Tunnels[i]);
    }
}

#define play_map_tunnels
for (var i = 0; i < global.NumTunnels; i++)
{
    var tnl = global.Tunnels[i];
    
    if (tnl == noone) continue;
    
    if (tnl._to != "")
    {
        tnl._to_tnl = play_find_tunnel(tnl._to);
    }
}


#define play_find_tunnel
var name = argument0;

for(var i = 0; i < global.NumTunnels; i++)
{
    var tnl = global.Tunnels[i];
    
    if (tnl == noone) continue;
    
    if (tnl._name == name) return tnl;
}

return noone;
