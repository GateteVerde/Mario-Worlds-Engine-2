///can_pull()

/*
**  Usage:
**      can_pull()
**
**  Returns:
**      Whether or not Mario is able to pull up an item.
*/

if (keyboard_check_pressed(vk_control))
&& (global.yoshi == 0)
&& (ready = false)
&& (obj_mario.canhold = 1)
&& (obj_mario.holding = 0)
&& (obj_mario.sliding = 0)
&& (obj_mario.disablecontrol = 0)
&& (obj_mario.state < cs_state_jump)
    return true;
else
    return false;
