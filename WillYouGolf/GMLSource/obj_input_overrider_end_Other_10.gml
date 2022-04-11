if (obj_player.x > x)
{
    if (obj_player.vspeed < 0)
        obj_player.vspeed *= 0.95
    obj_player.override_lookdir = 1
    if (global.input_x != 0)
        obj_player.lookdir = sign(global.input_x)
    global.input_x = 1
    global.input_reset = 0
}
