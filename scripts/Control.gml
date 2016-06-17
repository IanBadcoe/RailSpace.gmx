#define Control


#define control_step
if keyboard_check(vk_left)
{
    _X_offset -= 5;
}

if keyboard_check(vk_right)
{
    _X_offset += 5;
}

if keyboard_check(vk_up)
{
    _Y_offset -= 5;
}

if keyboard_check(vk_down)
{
    _Y_offset += 5;
}



#define control_draw_tile_array
var tile_array = argument0;
var parallax_factor = argument1;

for(var i = 0; i < global.TilesWidth; i++)
{
    for(var j = 0; j < global.TilesHeight; j++)
    {
        with(tile_array[i,j])
        {
            tile_draw(
                _tile,
                global.ScreenWidth / 2
                    + (i - global.TilesHalfWidth) * global.TileSize * parallax_factor
                    - other._X_offset * parallax_factor,
                global.ScreenHeight / 2
                    + (j - global.TilesHalfHeight) * global.TileSize * parallax_factor
                    - other._Y_offset * parallax_factor,
                _rot,
                _flip,
                parallax_factor);
        }
    }
}

#define control_draw
for(var i = 2; i >= 0; i--)
{
    draw_set_colour(global.LayerColours[i]);
    
    var tile_array = ds_list_find_value(_tiles, i);
    
    control_draw_tile_array(tile_array, global.LayerParallax[i]);
}