///mario_behaviour_climb();

/*
**  Name:
**      mario_behaviour_climb();
**
**  Function:
**      Handles the climbing behaviour of Mario.
*/
//Call uninitialized variables
var jumpstr = 3.4675;

//Cap horizontal speed
if (hspeed > 1)
hspeed = 1;
if (hspeed < -1)
hspeed = -1;

//Cap vertical speed
if (vspeed > 1)
vspeed = 1;
if (vspeed < -1)
vspeed = -1;

//Handle climbing
if (!disablecontrol) { //If Mario's controls are not disabled.

    //If the 'Right' key is held and the 'Left' key is not held.
    if (keyboard_check(vk_right)) && (!keyboard_check(vk_left)) {
    
        //Set the horizontal speed.
        hspeed = 1;
        
        //Set the facing direction.
        xscale = 1;
    }
    
    //Otherwise, if the 'Left' key is held and the 'Right' key not.
    else if (keyboard_check(vk_left)) && (!keyboard_check(vk_right)) {
    
        //Set the horizontal speed.
        hspeed = -1;
        
        //Set the facing direction.
        xscale = -1;
    }
    
    //Otherwise, if neither of the 'Left' or 'Right' keys are being held.
    else {
    
        hspeed = 0;
    }
    
    //If the 'Up' key is held and the 'Down' key is not held.
    if ((keyboard_check(vk_up)) && (!keyboard_check(vk_down))) {
    
        //If there's not a climbable surface above Mario.
        if (!collision_rectangle(bbox_left,bbox_top-1,bbox_right,bbox_top-1,obj_climb,0,0)) {
        
            //Stop vertical speed
            vspeed = 0;
        }
        else { //Otherwise, allow him to climb.
        
            //Set the vertical speed.
            vspeed = -1;
        }
    }
    
    //If the 'Down' key is held and the 'Up' key not.
    else if ((keyboard_check(vk_down)) && (!keyboard_check(vk_up))) {
    
        //If there's a semisolid below.
        if (collision_rectangle(bbox_left,bbox_bottom+1,bbox_right,bbox_bottom+2,obj_semisolid,0,0)) {
        
            //Stop climbing
            state = cs_state_jump;
        }
        else {
        
            //Set the vertical speed.
            vspeed = 1;
        }
    }
    
    //Otherwise, if neither of the 'Up' or 'Down' keys are being held.
    else    
        vspeed = 0;
    
    //Make Mario able to jump.
    if (keyboard_check_pressed(vk_shift)) { //If the 'Shift' key is pressed and Mario is not jumping.
    
        //Play 'Jump' sound.
        audio_play_sound(snd_jump, 0, false);
        
        //Make the player able to vary the jump.
        jumping = 1;
        
        //Set the jumping state.
        state = cs_state_jump;
        
        //Set the vertical speed.
        vspeed = -jumpstr+abs(hspeed)/7.5*-1;               
    }
}

//Check if there's a not climbable surface overlapping Mario.
if (!collision_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,obj_climb,0,0))
    state = cs_state_jump;
