#define EditMisc

#define edit_deselect_all
global._selected_points[0] = noone;
global._selected_points[1] = noone;
global._selected_points[2] = noone;
#define edit_request_string
var msg = argument0;
var def = argument1;

_paused = true;

_msg = get_string_async(msg, def);

_paused = false;

#define edit_retrieve_requested_string
var i_d = ds_map_find_value(async_load, "id");

if i_d == _msg
{
    if ds_map_find_value(async_load, "status")
    {
        return ds_map_find_value(async_load, "result");
    }
}

return noone;