///mario_behaviour_slide();

/*
**  Name:
**      mario_behaviour_slide();
**
**  Function:
**      Handles the sliding behaviour of Mario.
*/

//Call uninitialized variables.
var hspeedmax = 2.7;
var jumpstr = 3.4675;
var grav = 0.3625

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
    
//Make Mario able to jump.
if (!disablecontrol) { //If Mario's controls are not disabled.
    
    //If the player presses the 'Shift' key and Mario is sliding down a slope.
    if (keyboard_check_pressed(vk_shift)) 
    && (jumping == 0)
    && (vspeed == 0) {
    
        //Play 'Jump' sound.
        audio_play_sound(snd_jump,0,false);
        
        //Make the player able to vary the jump.
        jumping = 1;
                
        //Set the jumping state.
        sliding = 0;
        
        //Switch to jump state
        state = cs_state_jump;
        
        //Set the vertical speed.
        vspeed = -jumpstr+abs(hspeed)/7.5*-1;      
    }
}

//Make Mario accelerate when sliding down a slope.
if (collision_rectangle(x-1,bbox_bottom,x+1,bbox_bottom+1,obj_slopeparent,1,0)) 
|| (collision_rectangle(x-1,bbox_bottom,x+1,bbox_bottom+1,obj_platformparent_slope,1,0)) {

    //22.5º Right Slope
    if (collision_rectangle(x-1,bbox_bottom,x+1,bbox_bottom+1,obj_slope_r,1,0))  
        hspeed -= 0.1;
    
    //22.5º Left Slope
    else if (collision_rectangle(x-1,bbox_bottom,x+1,bbox_bottom+1,obj_slope_l,1,0))   
        hspeed += 0.1;
    
    //45º Right Slope
    else if (collision_rectangle(x-1,bbox_bottom,x+1,bbox_bottom+1,obj_slope_sr,1,0))
    || (collision_rectangle(x-1,bbox_bottom,x+1,bbox_bottom+1,obj_platform_slope_r,1,0))
        hspeed -= 0.15;
    
    //45º Left Slope
    else if (collision_rectangle(x-1,bbox_bottom,x+1,bbox_bottom+1,obj_slope_sl,1,0))
    || (collision_rectangle(x-1,bbox_bottom,x+1,bbox_bottom+1,obj_platform_slope_l,1,0))   
        hspeed += 0.15;
}

//Make Mario decelerate when not sliding down a slope.
else {

    //If Mario is on contact with the floor.
    if (collision_rectangle(bbox_left,bbox_bottom,bbox_right,bbox_bottom+2,obj_semisolid,0,0))
    || (collision_rectangle(x-1,bbox_bottom+1,x+1,bbox_bottom+1,obj_platformparent,1,0)) {
    
        //If Mario is not on contact with a slippery surface.
        if (!collision_rectangle(bbox_left,bbox_bottom,bbox_right,bbox_bottom,obj_slippery,0,0)) {
        
            //Slowdown
            hspeed = max(0,abs(hspeed)-0.05)*sign(hspeed);
            if ((hspeed > -0.05) && (hspeed < 0.05)) {
            
                //Stop horizontal speed.
                hspeed = 0;
                
                //Stop sliding behaviour
                sliding = false;
            }
        }
        
        //Otherwise, if Mario is on contact with a slippery surface.
        else if (collision_rectangle(bbox_left,bbox_bottom,bbox_right,bbox_bottom,obj_slippery,0,0)) {
        
            //Slowdown
            hspeed = max(0,abs(hspeed)-0.0125)*sign(hspeed);
            if ((hspeed > -0.0125) && (hspeed < 0.0125)) {
            
                //Stop horizontal speed.
                hspeed = 0;
                
                //Stop sliding behaviour
                sliding = false;
            }        
        }
    }
}

//Prevent Mario from sliding too fast.
if (abs(hspeed) > hspeedmax)
    hspeed = max(0,abs(hspeedmax)-0.05*2)*sign(hspeed);
    
//Apply gravity
if ((state == 2) || (statedelay > 0))
    gravity = grav;
