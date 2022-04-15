//This complicated chunk of code determines the position the players hat should be, I've modified it to use variables for the offsets for easy modification.
//I would add these to the character configuration file, however, these functions are complex(or atleast complicated) and I haven't fully figured out how they work yet.

if victory
{
    if (obj_player.x < 60)
        x -= 10
    if (obj_player.y < 60)
        y -= 10
    if (obj_player.x > (room_width - 60))
        x += 10
    if (obj_player.y > (room_height - 60))
        y += 10
}
else if dead
{
    yspeed += 0.4
    x += xspeed
    y += yspeed
    image_angle += sign(image_angle)
}
else
{
x = obj_player.x + lengthdir_x(16, image_angle + 90)
y = obj_player.y + lengthdir_y(16, image_angle + 90)
image_angle += obj_player.hspeed * -1
}