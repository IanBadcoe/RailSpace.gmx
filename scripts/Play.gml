#define Play


#define play_load_level
var fname = working_directory + global._level_file;

file_load(fname);
#define play_level_setup
global.PlayerTrain = train_create_player_train();

play_map_tunnels();

for(var i = 0; i < global.NumTunnels; i++)
{
    if (global.Tunnels[i] != noone && global.Tunnels[i]._player_start)
    {
        with global.PlayerTrain train_follow_track_from_tunnel(global.Tunnels[i]);
    }
}

#define play_map_tunnels
for (var i = 0; i < global.NumTunnels; i++)
{
    var tnl = global.Tunnels[i];
    
    if (tnl == noone) continue;
    
    tnl._to_tnl = noone;
    
    if (tnl._to != -1)
    {
        tnl._to_tnl = global.Tunnels[tnl._to];
    }
}

#define play_process_enemy_entrances
var time = (current_time - global.LevelStarted) / 1000;

with (obTunnel)
{
    if (_enemy_type != -1 && _enemy_delay != -1)
    {
        if (time > _enemy_delay)
        {
            play_add_enemy_from_tunnel(self);
            _enemy_delay = -1;
        }
    }
}


#define play_add_enemy_from_tunnel
var enemy = play_create_enemy_by_type(_enemy_type);

with enemy train_follow_track_from_tunnel(other);

#define play_create_enemy_by_type
var inst = instance_create(0, 0, obEnemyEngine);

inst._total_weight = inst._weight;

var wgn = instance_create(0, 0, obFlatbed);
inst._coupled_backwards = wgn;
wgn._coupled_forwards = inst;

inst._total_weight += wgn._weight;

var wgn2 = instance_create(0, 0, obFlatbed);
wgn._coupled_backwards = wgn2;
wgn2._coupled_forwards = wgn;

inst._total_weight += wgn2._weight;

return inst;