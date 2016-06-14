#define Control


#define control_step
if keyboard_check(vk_left)
{
    _X -= 5;
}

if keyboard_check(vk_right)
{
    _X += 5;
}

if keyboard_check(vk_up)
{
    _Y -= 5;
}

if keyboard_check(vk_down)
{
    _Y += 5;
}



#define control_draw
for(var i = 0; i < array_height_2d(_tile_rots); i++)
{
    for(var j = 0; j < array_length_2d(_tile_rots, i); j++)
    {
        with(_tiles[i,j])
        {
            tile_draw(i * 100 - other._X, j * 100 -other._Y,
                other._tile_rots[i, j], other._tile_flips[i,j]);
        }
    }
}