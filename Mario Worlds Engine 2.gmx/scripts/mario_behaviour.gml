///mario_behaviour();

/*
**  Name:
**      mario_behaviour();
**
**  Function:
**      Handles the default behaviour of Mario.
*/

//Call uninitialized variables.
var hspeedmax = 1.35;
var jumpstr = 3.4675;
var acc = 0.05;
var accfrog = 0.13;
var accskid = 0.15;
var dec = 0.0375;
var decskid = 0.072;
var grav = 0.3625
var grav_alt = 0.0625;

//Figure out Mario's state.
if ((collision_rectangle(bbox_left,bbox_bottom+1,bbox_right,bbox_bottom+1,obj_semisolid,0,0))
|| (collision_rectangle(bbox_left,bbox_bottom+1,bbox_right,bbox_bottom+1,obj_platformparent,0,0))
|| (collision_rectangle(x-1,bbox_bottom+1,x+1,bbox_bottom+1,obj_slopeparent,1,0))
|| (collision_rectangle(x-1,bbox_bottom+1,x+1,bbox_bottom+1,obj_platformparent_slope,1,0)))
&& (vspeed >= 0) {

    //Figure out if Mario is standing or walking
    if (hspeed == 0)
        state = cs_state_idle;
    else
        state = cs_state_walk;

    //Reset state delay
    statedelay = 0;
}

//Mario is jumping if there's no ground below him.
else {

    //Delay the change to the jump state
    if (statedelay > 4)
        state = cs_state_jump;
    else
        statedelay++;
}

//Prevent Mario from falling too fast.
if (vspeed > 4)
    vspeed = 4;
    
//Set up Mario's maximum horizontal speed.
//Collision with 45ª slopes
if ((collision_rectangle(bbox_left,bbox_bottom,bbox_right,bbox_bottom+4,obj_slope_sr,1,0)) && (hspeed > 0))
|| ((collision_rectangle(bbox_left,bbox_bottom,bbox_right,bbox_bottom+4,obj_slope_sl,1,0)) && (hspeed < 0))
|| ((collision_rectangle(bbox_left,bbox_bottom,bbox_right,bbox_bottom+4,obj_platform_slope_r,1,0)) && (hspeed > 0))
|| ((collision_rectangle(bbox_left,bbox_bottom,bbox_right,bbox_bottom+4,obj_platform_slope_l,1,0)) && (hspeed < 0))
    hspeedmax = 0.675;
    
//Collision with 22.5ª slopes.
else if ((collision_rectangle(bbox_left,bbox_bottom,bbox_right,bbox_bottom+4,obj_slope_r,1,0)) && (hspeed > 0))
|| ((collision_rectangle(bbox_left,bbox_bottom,bbox_right,bbox_bottom+4,obj_slope_l,1,0)) && (hspeed < 0))
    hspeedmax = 1.35;

//Otherwise, set default limits.
else {

    //If Mario is not flying.
    if (!flying) {
    
        if (keyboard_check(vk_control)) { //If the control key is being held.
            
            //If the P-Meter is filled up.
            if (run)  
                hspeedmax = 3.3;
            
            //Otherwise, if the P-Meter is not filled up.
            else    
                hspeedmax = 2.7;
        }               
        
        //Otherwise, do not reduce speed until Mario makes contact with the ground.  
        else  
            hspeedmax = 1.35;
    }
    
    //Otherwise, if Mario is flying.
    else 
        hspeedmax = 2;
}
    
//Cap Mario's horizontal speed when on ground.
if (state < cs_state_jump) 
|| ((state = cs_state_jump) && (flying)) {

    if (hspeed > hspeedmax)
        hspeed -= acc;
    else if (hspeed < -hspeedmax)
        hspeed += acc;
}

//Handle basic movements
if ((!disablecontrol) && (!inwall)) { //If Mario's controls are not disabled.

    //Make Mario able to jump when is on contact with the ground.
    if (keyboard_check_pressed(vk_shift))
    && (canjump == 1)
    && (jumping == 0)
    && (vspeed == 0) 
    && (state != cs_state_jump) 
    && (!collision_rectangle(bbox_left,bbox_bottom,bbox_right,bbox_bottom+2,obj_noteblock,0,0)) { //If the 'Shift' key is pressed and Mario is not jumping.
    
        //If 'Up' is being held.
        if ((keyboard_check(vk_up)) && (holding == 0)) {
            
            //Play 'Spin' sound.
            audio_play_sound(snd_spin, 0, false);
            
            //Set 'Spin' jump
            spin = true;
            
            //Set the vertical speed.
            vspeed = -jumpstr;        
        }
        
        //Otherwise, if it's not held.
        else {
        
            //Play 'Jump' sound.
            audio_play_sound(snd_jump, 0, false);
            
            //Set default jump
            spin = false;
            
            //Set the vertical speed.
            vspeed = -jumpstr+abs(hspeed)/7.5*-1;
        }
        
        //Make the player able to vary the jump.
        jumping = 1;
        
        //Switch to jump state
        state = cs_state_jump;
        
        //Move Mario a few pixels upwards when on contact with a moving platform or a slope.
        var platform = collision_rectangle(bbox_left,bbox_bottom,bbox_right,bbox_bottom+1,obj_semisolid,0,0);
        if ((platform) && (platform.vspeed < 0))
            y -= 4;
    }
    
    //Make Mario fall if the player releases the 'Shift' key.
    else if ((jumping == 1) && (keyboard_check_released(vk_shift)))         
        jumping = 2;
    
    //Enable / Disable Movement.
    toggle_movement();
    
    //Handle Horizontal Movement.
    //If the player holds the 'Right' key and the 'Left' key is not being held.
    if ((keyboard_check(vk_right)) && (!keyboard_check(vk_left)) && (move)) {
    
        //Set up the facing direction and make mario turn if it's holding something.
        if ((xscale != 1) && (holding == 1)) {
        
            turning = 1;
            alarm[3] = 4;
        }
        
        //Set the facing direction.
        xscale = 1;
        
        //If there's NOT a wall on the way.
        if (!collision_rectangle(bbox_right,bbox_top+4,bbox_right+1,bbox_bottom-1,obj_solid,1,0)) 
        && (!collision_rectangle(bbox_right,bbox_top+4,bbox_right+2,bbox_bottom-1,obj_platformparent_solid,1,0)) {
        
            //Check up Mario's horizontal speed
            if (hspeed < hspeedmax) {
                            
                //Make Mario move horizontally.
                if (!collision_rectangle(bbox_left,bbox_bottom,bbox_right,bbox_bottom,obj_slippery,0,0)) { //If Mario is overlapping a slippery surface.
                    
                    //If Mario's horizontal speed is equal/greater than 0.
                    if (hspeed >= 0) {
                    
                        //Add 'acc' to hspeed.
                        hspeed += acc;
                    }
                    else { //Otherwise, if Mario's speed is lower than 0.
                    
                        //Add 'accskid' to hspeed;
                        hspeed += accskid;
                    }
                }
                else { //Otherwise, if Mario is overlapping a slippery surface.
                
                    //If Mario's horizontal speed is equal/greater than 0.
                    if (hspeed >= 0) {
                    
                        //Add 'acc' to hspeed
                        hspeed += acc/2;
                    }
                    else { //Otherwise, if Mario's speed is lower than 0.
                    
                        //Add 'accskid' to hspeed.
                        hspeed += accskid/2;
                    }                                              
                }
            }
        }
    }
    
    //If the player holds the 'Left' key and the 'Right' key is not being held.
    else if ((keyboard_check(vk_left)) && (!keyboard_check(vk_right)) && (move)) {
    
        //Set up the facing direction and make mario turn if it's holding something.
        if ((xscale != -1) && (holding == 1)) {
        
            turning = 1;
            alarm[3] = 4;
        }
        
        //Set the facing direction.
        xscale = -1;
        
        //If there's NOT a wall on the way.
        if (!collision_rectangle(bbox_left-1,bbox_top+4,bbox_left,bbox_bottom-1,obj_solid,1,0)) 
        && (!collision_rectangle(bbox_left-2,bbox_top+4,bbox_left,bbox_bottom-1,obj_platformparent_solid,1,0)) {
        
            //Check up Mario's horizontal speed.
            if (hspeed > -hspeedmax) {
                    
                //Make Mario move horizontally.
                if (!collision_rectangle(bbox_left,bbox_bottom,bbox_right,bbox_bottom,obj_slippery,0,0)) { //If Mario is overlapping a slippery surface.
                    
                    //If Mario's horizontal speed is equal/lower than 0.
                    if (hspeed <= 0) {
                        
                        //Add 'acc' to hspeed.
                        hspeed += -acc;
                    }
                    else { //Otherwise, if Mario's speed is greater than 0.
                    
                        //Add 'accskid' to hspeed;
                        hspeed += -accskid;
                    }
                }
                else { //Otherwise, if Mario is overlapping a slippery surface.
                
                    //If Mario's horizontal speed is equal/lower than 0.
                    if (hspeed <= 0) {
                    
                        //Add 'acc' to hspeed
                        hspeed += -acc/2;
                    }
                    else { //Otherwise, if Mario's speed is greater than 0.
                    
                        //Add 'accskid' to hspeed.
                        hspeed += -accskid/2;
                    }                                              
                }
            }
        }
    }
    
    //Otherwise, if Mario is on contact with the ground.
    else if (vspeed == 0) { 
    
        //If Mario is not overlapping a slippery surface.
        if (!collision_rectangle(bbox_left,bbox_bottom,bbox_right,bbox_bottom,obj_slippery,0,0)) {
        
            //If Mario is not crouched down.
            if (!duck) {
            
                //Reduce Mario's speed until he stops.
                hspeed = max(0,abs(hspeed)-dec)*sign(hspeed);
                
                //Set up horizontal speed to 0 when hspeed hits the value given on 'dec'.
                if ((hspeed < dec) && (hspeed > -dec))             
                    hspeed = 0;
            }
            else { //If Mario is crouched down.
            
                //Reduce Mario's speed until he stops.
                hspeed = max(0,abs(hspeed)-dec)*sign(hspeed);
                
                //Set up horizontal speed to 0 when hspeed hits the value given on 'dec'.
                if ((hspeed < decskid) && (hspeed > -decskid))                
                    hspeed = 0;
            }
        }
        else { //Otherwise, if Mario is overlapping a slippery surface.
        
            //Reduce Mario's speed until he stops.
            hspeed = max(0,abs(hspeed)-dec/8)*sign(hspeed);
            
            //Set up horizontal speed to 0 when hspeed hits the value given on 'dec'.
            if ((hspeed < dec/8) && (hspeed > -dec/8))          
                hspeed = 0;
        }
    }
}

//Otherwise, if Mario's controls are disabled and Mario is on contact with the ground.
else if (vspeed == 0) { 
        
    //If Mario is not overlapping a slippery surface.
    if (!collision_rectangle(bbox_left,bbox_bottom,bbox_right,bbox_bottom,obj_slippery,0,0)) {
    
        //If Mario is not crouched down.
        if (!duck) {
        
            //Reduce Mario's speed until he stops.
            hspeed = max(0,abs(hspeed)-dec)*sign(hspeed);
            
            //Set up horizontal speed to 0 when hspeed hits the value given on 'dec'.
            if ((hspeed < dec) && (hspeed > -dec))         
                hspeed = 0;
        }
        else { //If Mario is crouched down.
        
            //Reduce Mario's speed until he stops.
            hspeed = max(0,abs(hspeed)-dec)*sign(hspeed);
            
            //Set up horizontal speed to 0 when hspeed hits the value given on 'dec'.
            if ((hspeed < decskid) && (hspeed > -decskid))        
                hspeed = 0;
        }
    }
    else { //Otherwise, if Mario is overlapping a slippery surface.
    
        //Reduce Mario's speed until he stops.
        hspeed = max(0,abs(hspeed)-dec/8)*sign(hspeed);
        
        //Set up horizontal speed to 0 when hspeed hits the value given on 'dec'.
        if ((hspeed < dec/8) && (hspeed > -dec/8))   
            hspeed = 0;
    }
}

//If Mario is jumping
if ((state == cs_state_jump) || (statedelay > 0)) {
    
    //Variable jumping
    if (vspeed < -2) && (jumping == 1) {
    
        //Use alternate gravity
        gravity = grav_alt;
    }   
    
    //Otherwise, use alternate gravity.     
    else {
    
        //Use default gravity
        gravity = grav;
        
        //End variable jumping if it never ends manually.
        if (jumping = 1)
            jumping = 2;
    }

    //If Mario is using the raccoon or the tanooki powerup.
    if (global.powerup == cs_leaf) {
    
        //If gravity is disabled.
        if (disablegrav > 0) {
        
            if (state != cs_state_jump) {
            
                //Enable gravity
                disablegrav = 0;
            }
            else {
            
                //Deny gravity
                gravity = 0;
                
                //Enable gravity
                disablegrav--;
            }
        }
    }
    
    //Otherwise, if Mario is performing the special fire attack.
    else if ((global.powerup == cs_fire) && (special)) {

        //If gravity is disabled.
        if (disablegrav > 0) {
        
            if (state != cs_state_jump) {
            
                //Enable gravity
                disablegrav = 0;
            }
            else {
            
                //Deny gravity
                gravity = 0;
                
                //Enable gravity
                disablegrav--;
            }
        }
    }
    
    //Otherwise, enable gravity.
    else
        disablegrav = 0;
}

//Makes Mario start climbing.
if (canclimb) { //If Mario can climb a fence or a vine.

    //Climb if overlapping a climbing surface.
    if (collision_rectangle(bbox_left,bbox_top,bbox_right,bbox_top,obj_climb,0,0))
    && (holding = 0)
    && (!disablecontrol)
    && (keyboard_check(vk_up)) {
    
        //Change to climbing state
        state = cs_state_climb;
        
        //Stop movement
        gravity = 0;
        speed = 0;
        
        //Set the climbing style
        climbstyle = 0;
    }
    
    //Check for a alternative climbing object
    var climb = collision_rectangle(bbox_left,bbox_top,bbox_right,bbox_top,obj_climb_alt,0,0);
    if (climb)
    && (holding == 0)
    && (canhang == 0)
    && (state != cs_state_climb) {
    
        //If there's a solid above.
        if (collision_rectangle(bbox_left,bbox_top,bbox_right,bbox_top,obj_solid,1,0))
        exit;
        
        //Set climbing state
        state = cs_state_climb;
        
        //Snap into position
        x = climb.x+8;
        
        //Makes Mario climb
        canhang = 1;        
        
        //Stop movement
        gravity = 0;
        speed = 0;
        
        //Set the climbing style
        climbstyle = 1;        
    }
}

//Makes Mario butt-slide down slopes
if (keyboard_check_pressed(vk_down))
&& (disablecontrol == 0) {

    //If Mario is on a slope, and the above didn't happen, slide normally
    if (collision_point(x+1,bbox_bottom+2,obj_slopeparent,1,0))
    || (collision_point(x-1,bbox_bottom+2,obj_slopeparent,1,0)) {
    
        //If Mario can slide and it's not holding anything.
        if ((canslide) && ((holding != 1) && (holding != 2)))
            sliding = true;
            
        //Otherwise, just crouch down if Mario can do it.
        else if (canduck)
            duck = true;
    }       
}

//Make Mario able to fly or slowdown his fall.
if (global.powerup == cs_leaf)
&& (dismount == 0)
&& (jumping != 1)
&& (spin == false)
&& (swimming == false)
&& (state == cs_state_jump)
&& (keyboard_check_pressed(vk_shift)) {

    //If Mario is running.
    if (run) {
    
        //Play 'tail' sound.
        audio_stop_sound(snd_spin);
        audio_play_sound(snd_spin,0,0);
        
        //If Mario can fly
        if (canfly) {
        
            //Make Mario able to fly for 4 seconds
            if (!flying) {
            
                flying = true;
                alarm[9] = 240;
            }
            
            //Whip tail.
            wiggle = 16;
            
            //Disable gravity.
            disablegrav = 16;            
            
            //Set the vertical speed.
            if (alarm[9] > 30)  
                vspeed = -1.5;
            else {
            
                if (vspeed < 0)
                    vspeed  = max(vspeed + 0.5, 0);
                else
                    vspeed = 0;
            }
        }
        
        //Otherwise, if Mario cannot fly
        else if (!canfly) { 
            
            //Whip tail.
            wiggle = 16;
            
            //Disable gravity.
            disablegrav = 16;
            
            //Set the vertical speed.
            vspeed = 0.75;        
        }
    }
    
    //Otherwise, if Mario is not running.
    else if (!run) { 
    
        //Play 'tail' sound.
        audio_stop_sound(snd_spin);
        audio_play_sound(snd_spin,0,0);      
        
        //Whip tail.
        wiggle = 16;
        
        //Disable gravity.
        disablegrav = 16;
        
        //Set the vertical speed.
        vspeed = 0.75;
    }
}
