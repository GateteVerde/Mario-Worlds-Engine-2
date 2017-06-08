///bounce();

/*
**  Name:
**      bounce();
**
**  Function:
**      Makes Mario bounce when called.
*/

//Set the vertical speed.
vspeed = -3.9;

//Move 6 pixels upwards.
y -= 6;

//Let mario vary his jump.
if (keyboard_check(vk_shift))
    jumping = 1;
else
    jumping = 2;
