///can_hold()

/*
**  Usage:
**      can_hold()
**
**  Returns:
**      Whether or not Mario is able to hold an item.
*/

if (keyboard_check(vk_control))
&& (global.yoshi == 0)
&& (obj_mario.holding = 0)
&& (obj_mario.sliding = 0)
&& (obj_mario.canhold = 1)
&& (obj_mario.disablecontrol = 0)
&& (obj_mario.state < cs_state_climb)
    return true;
else
    return false;
