image_xscale = 0.5
image_yscale = 0.5

unicorn_power = (instance_exists(obj_boss) or instance_exists(obj_boss_p2))

if (unicorn_power)
{
	golfball_bounce_power *= 0.98
}

if (golfball_current_phase == 0)
{
	
	if (snailtype == 0)
	{
		golfball_current_angle = point_direction(x,y,mouse_x,mouse_y)
	}
	else if (object_index == obj_evil_snail)
	{
		golfball_current_angle = point_direction(obj_player.x,obj_player.y,mouse_x,mouse_y) + 180
	}
	else
	{
		golfball_current_angle = point_direction(x,y,x + irandom_range(-300,300),y + irandom_range(-300,300))
	}
	
	golfball_current_strength = clamp(point_distance(x,y,mouse_x,mouse_y) / 7, 5, 50)

	if ((floor(vspeed) == 0 or (global.current_character == #char_scp018#)) and (round(hspeed) == 0 or place_meeting(x, y, obj_conveyor_belt)) and (not place_free(x,y+clamp(3 * golfball_grav_mult, -3, 3)) or (global.current_character == #char_scp018#)))
	{
		golfball_still = true
		golfball_air_puts = golfball_max_air_puts + (unicorn_power ? 1 : 0)
	}
	else
	{
		golfball_still = false
		if (inbubble)
		{
			vspeed -= 0.1
			if (golfball_air_puts == 1)
			{
				golfball_current_strength *= 0.3
			}
			else
			{
				golfball_current_strength *= 0.8
			}
		}
		else
		{
			if (golfball_air_puts == 1 and unicorn_power)
			{
				golfball_current_strength *= 0.38
			}
			else
			{
				golfball_current_strength *= 0.6
			}
		}
	}
	
	if (object_index == obj_evil_snail)
	{
		golfball_current_strength *= 0.95
	}

	if (inputjumppress)
	{
		//golfball_current_phase = 1
		if (golfball_still)
		{
			motion_add(golfball_current_angle, golfball_current_strength)
			if (snailtype == 0)
			{
				golfball_hits++
			}
			timesincelastjump = 0
			if (snailtype == 0)
			{
				audio_play_sound(sou_golf_hit,0,false)
				audio_sound_pitch(sou_golf_hit,random_range(0.8,1.2))
			}
		}
		else
		{
			if (golfball_air_puts > 0)
			{
				golfball_air_puts--
				if (not inbubble)
				{
					if (snailtype == 0)
					{
						audio_play_sound(sou_golf_hit,0,false)
						audio_sound_pitch(sou_golf_hit,random_range(0.8,1.2))
					}
					vspeed = 0
					hspeed = 0
				}
				else
				{
					if (snailtype == 0)
					{
						audio_play_sound(sou_golf_hit,0,false)
						audio_sound_pitch(sou_golf_hit,random_range(0.6,0.8))
					}
				}
				motion_add(golfball_current_angle, golfball_current_strength)
				if (snailtype == 0)
				{
					golfball_hits++
				}
				timesincelastjump = 0
				if (inbubble and golfball_air_puts == 0)
				{
					if (snailtype == 0)
					{
						sound = audio_play_sound(choose(sou_BubbleLeave_A, sou_BubbleLeave_B), 0.8, false)
						audio_sound_gain_fx(sound, 0.75, 0)
						audio_sound_pitch(sound, (2 + random(0.2)))
						scr_exit_bubble()
					}
					inbubble = 0
				}
			}
		}
	}
	

}

if (!inbubble)
{
	vspeed += (1.5 * golfball_grav_mult)
}
else
{
	vspeed *= 0.94
}
if (global.current_character != #char_rubberball#)
{
	hspeed *= underwater ? golfball_friction[1] : golfball_friction[0]
}

water_current = collision_point(x, y, obj_underwater_current, 1, 1)
timesincelastjump++
if instance_exists(water_current)
{
	if (timesincelastjump > 20)
	{
		vspeed = 0.7
	}
	golfball_air_puts = 2
	if (snailtype == 0)
	{
		in_water_current = lerp(in_water_current, 1, 0.1)
		if (global.player_underwater_current_timer < 100)
			global.player_underwater_current_timer += 1
	}
}

if place_meeting(x, y, obj_conveyor_belt)
{
	hspeed += ((global.conveyor_belt_speed * sign(global.conveyor_belt_direction)) * 0.08) * conveyor_multiplier
	if (snailtype == 0)
	{
		if (global.player_on_conveyor_timer <= 0)
			global.player_on_conveyor_timer = 1
		bonus_speed_by_conveyor = (global.conveyor_belt_speed * sign(global.conveyor_belt_direction)) * conveyor_multiplier
	}
}

if (not place_free(x + hspeed,y))
{
	if (abs(hspeed) >= 30 and (global.current_character == #char_dirtball#) and snailtype == 0)
	{
		global.last_death_by_hspeed = hspeed
		global.last_death_by_vspeed = vspeed
		global.last_death_by_image_anlge = 0
		global.last_death_by = -1
		scr_death_feedback_for_obj(other)
		global.last_death_by_image_anlge = 0
		scr_player_death(point_direction(0, 0, hspeed, vspeed), abs(hspeed) * 1.2)
	}
	hspeed *= -golfball_side_bounce_power
	if (snailtype == 0)
	{
		audio_play_sound(choose(sou_golf_land, sou_golf_land_b, sou_golf_land_c),0,false)
	}
	if (inbubble)
	{
		if (snailtype == 0)
		{
			sound = audio_play_sound(choose(sou_BubbleLeave_A, sou_BubbleLeave_B), 0.8, false)
			audio_sound_gain_fx(sound, 0.75, 0)
			audio_sound_pitch(sound, (2 + random(0.2)))
			scr_exit_bubble()
		}
		inbubble = 0
	}
}

if (not place_free(x,y + vspeed))
{
	if ((golfball_grav_mult < 0 and (vspeed >= -10) and (vspeed <= 0)) or (golfball_grav_mult > 0 and (vspeed <= 10) and (vspeed >= 0)))
	{
		if (vspeed > 0)
		{
			while (not place_free(x,y + 1))
			{
				y--
			}
		}
		else
		{
			while (not place_free(x,y - 1))
			{
				y++
			}
		}
		vspeed = 0
		if (global.current_character == #char_rubberball#)
		{
			hspeed *= underwater ? golfball_friction[1] : golfball_friction[0]
		}
	}
	else
	{
		if (abs(vspeed) >= 30 and (global.current_character == #char_dirtball#) and snailtype == 0)
		{
			global.last_death_by_hspeed = hspeed
			global.last_death_by_vspeed = vspeed
			global.last_death_by_image_anlge = 0
			global.last_death_by = -1
			scr_death_feedback_for_obj(other)
			global.last_death_by_image_anlge = 0
			scr_player_death(point_direction(0, 0, hspeed, vspeed), abs(vspeed) * 1.2)
		}
		vspeed *= -golfball_bounce_power
		if (snailtype == 0)
		{
			audio_play_sound(choose(sou_golf_land, sou_golf_land_b, sou_golf_land_c),0,false)
		}
		if (global.current_character == #char_rubberball#)
		{
			hspeed *= underwater ? golfball_friction[1] : golfball_friction[0]
		}
	}
	if (inbubble)
	{
		if (snailtype == 0)
		{
			sound = audio_play_sound(choose(sou_BubbleLeave_A, sou_BubbleLeave_B), 0.8, false)
			audio_sound_gain_fx(sound, 0.75, 0)
			audio_sound_pitch(sound, (2 + random(0.2)))
			scr_exit_bubble()
		}
		inbubble = 0
	}
}

if (hspeed > 0)
{
	lookdir = 1
}

if (hspeed < 0)
{
	lookdir = -1
}

if (global.current_character == #char_magball#)
{
	attempty = 0
	attempts = 0
	ceiling_y = 0
	floor_y = 0
	while (!place_free(x,y-attempty))
	{
		if (attempts >= 1080)
		{
			return false
		}
		attempty++
		attempts++
	}
	ceiling_y = attempty
	attempts = 0
	attempty = 0
	while (!place_free(x,y+attempty))
	{
		if (attempts >= 1080)
		{
			return false
		}
		attempty++
		attempts++
	}
	floor_y = attempty
	
	if (floor_y <= ceiling_y)
	{
		target_gravity = 1
	}
	else
	{
		target_gravity = -1
	}
}


return false
