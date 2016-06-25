#define Train

#define train_create_player_train
var inst = instance_create(0, 0, obEngine);

inst._total_weight = inst._weight;


#define train_follow_curve
var trn = argument0;
var crv = argument1;
var dir = argument2;
var reg = argument3;

trn._curve = crv;
trn._curve_dir = dir;
trn._regulator = reg;
trn._speed = train_speed_for_regulator(trn, reg);

if (dir)
{
    trn._curve_pos = 0;
    
}
else
{
    trn._curve_pos = 1;
}


#define train_speed_for_regulator
var trn = argument0;
var reg = argument1;

return reg * trn._power / trn._total_weight;


#define train_step
var trn = argument0;

// when we have more than one rolling-stock, abort here unless we're the first
// let first cascade into us instead

// not on track
if (trn._curve == noone) exit;

train_update_speed(trn);

train_update_position(trn);


#define train_update_speed
trn._speed = (trn._speed * 10 + train_speed_for_regulator(trn, trn._regulator)) / 11;


#define train_update_position
var trn = argument0;

trn._curve_pos += trn._speed;

//trn._front_p = curve_pos


