draw_set_color(c_white)
draw_set_halign(fa_left)
draw_set_valign(fa_top)
draw_text(0,display_get_gui_height() / 2, "Hits:" + string(golfball_hits))
if (instance_exists(obj_boss) or instance_exists(obj_boss_p2))
{
	draw_set_color(obj_levelstyler.col_unicorn)
	draw_text(0,(display_get_gui_height() / 2) + 64, "UNICORN POWER!")
}