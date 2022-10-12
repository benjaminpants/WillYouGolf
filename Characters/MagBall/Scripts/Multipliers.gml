golfball_max_air_puts = 1
golfball_friction = [0.97,0.985] //first is ground, second is underwater
golfball_bounce_power = 0.7
golfball_side_bounce_power = 0.82
if (!variable_instance_exists(id, "target_gravity"))
{
	golfball_grav_mult = 1
	target_gravity = 1
}
else
{
	golfball_grav_mult = target_gravity
}