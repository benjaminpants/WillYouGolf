draw_sprite_ext(spr_ball,0,x, y, (((lookdir * 0.5) * image_xscale) * aw_OUT_xscale), ((image_yscale * 0.5) * aw_OUT_yscale), (image_angle + aw_OUT_angle), obj_levelstyler.col_ai, 1)

draw_sprite_ext(spr_mine_warning,4,mouse_x,mouse_y, 0.5, 0.5, 0, c_white, 1)


//draw_text(x,y,string(golfball_air_puts))
if (inbubble or (golfball_air_puts != 0) or golfball_still)
{
	var fakevspeed = lengthdir_y(golfball_current_strength,golfball_current_angle)
	var fakehspeed = lengthdir_x(golfball_current_strength,golfball_current_angle)
	var fakex = x
	var fakey = y
	var iamount = (golfball_still ? 6 : 3)
	//draw_line_width_colour(x,y,x + lengthdir_x(golfball_current_strength * 3 ,golfball_current_angle), y + lengthdir_y(golfball_current_strength * 3,golfball_current_angle), 8, c_red, golfball_still ? c_green : c_blue)
	for (var i = 0; i < iamount; i += 1)
	{
		repeat(7)
		{
			if (!inbubble)
			{
				fakevspeed += 1.5
			}
			else
			{
				fakevspeed *= 0.94
			}
			fakehspeed *= underwater ? 0.985 : 0.97
			if (not place_free(fakex + fakehspeed,fakey))
			{
				fakehspeed *= -0.82
			}
			if (not place_free(fakex,fakey + fakevspeed))
			{
				fakevspeed *= -0.7 //no need for that complicated infini-bounce code
			}
			if place_meeting(fakex, fakey, obj_conveyor_belt)
			{
				fakehspeed += ((global.conveyor_belt_speed * sign(global.conveyor_belt_direction)) * 0.08) * conveyor_multiplier
				if (snailtype == 0)
				{
					if (global.player_on_conveyor_timer <= 0)
						global.player_on_conveyor_timer = 1
					bonus_speed_by_conveyor = (global.conveyor_belt_speed * sign(global.conveyor_belt_direction)) * conveyor_multiplier
				}
			}
			fakex += fakehspeed
			fakey += fakevspeed
			draw_sprite_ext(spr_ball,0,fakex,fakey, 0.1, 0.1, 0, merge_colour(c_red,golfball_still ? c_green : c_blue,i / iamount), 1)
		}
	}
	

}