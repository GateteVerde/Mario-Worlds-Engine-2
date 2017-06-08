///mario_behaviour_climb_alt();

/*
**  Name:
**      mario_behaviour_climb_alt();
**
**  Function:
**      Handles the alternate climbing behaviour of Mario.
*/

//Temporary variable
var jumpstr = 3.4675;

//Make the player face left.
if (keyboard_check(vk_right)) {

    //Set the facing direction
    xscale = -1;

    //Release the vine if the key has been held enough.
    canturn++;
    if (canturn > 19) {
    
        //Set the jumping state.
        state = cs_state_jump;
        
        //Disallow climbing
        alarm[2] = 12;        
        canhang = 2;
        
        //End variable jumping
        jumping = 2;
        
        //Set movement
        hspeed = -xscale*2;
        
        //Set the facing direction
        xscale = 1*sign(hspeed);
    }
}
else if (keyboard_check(vk_left))  {

    //Set the facing direction
    xscale = 1;

    //Release the vine if the key has been held enough.
    canturn++;
    if (canturn > 19) {
    
        //Set the jumping state.
        state = cs_state_jump;
        
        //Disallow climbing
        alarm[2] = 12;        
        canhang = 2;
        
        //End variable jumping
        jumping = 2;
        
        //Set movement
        hspeed = -xscale*2;
        
        //Set the facing direction
        xscale = 1*sign(hspeed);
    }
}
else { //Reset hangout variable

    canturn = 0;
}

//Move up if 'Up' is held.
if ((keyboard_check(vk_up)) && (!keyboard_check(vk_down))) {

    if (!collision_rectangle(bbox_left,y,bbox_right,y,obj_climb_alt,0,0))
        vspeed = 0;
    else {

        //Set the vertical speed.
        vspeed = -1;
    }
}

//Move down if 'Down' is held.
else if ((keyboard_check(vk_down)) && (!keyboard_check(vk_up))) {

    //Set the vertical speed.
    vspeed = 1;
}

//Otherwise, stop Mario.
else {

    //Stop vertical movement.
    vspeed = 0;
}

//Make the player jump.
if (keyboard_check_pressed(vk_shift)) {

    //Play 'Jump' sound
    audio_play_sound(snd_jump, 0, false);   
    
    //Set the jumping state.
    state = cs_state_jump;
    
    //Disallow climbing
    alarm[2] = 12;
    canhang = 2;
    
    //End variable jumping
    jumping = 1;
        
    //Set movement
    vspeed = -jumpstr;
    hspeed = -xscale*2;
    
    //Move Mario 8 pixels
    x -= 8*sign(xscale);     
    
    //Set the facing direction
    xscale = 1*sign(hspeed);
}

//Makes the player move down when there's not a climbable surface above.
if (!collision_rectangle(bbox_left,y,bbox_right,bbox_bottom,obj_climb_alt,0,0)) {

    if (vspeed < 0)
        vspeed = 0
    else {
    
        //Set the 'Jumping' phase.
        state = cs_state_jump;
                    
        //Disallow climbing
        alarm[2] = 12;
        canhang = 2;
                
        //Allow variable jumping
        jumping = 1;
        
        //Move Mario 8 pixels
        x -= 8*sign(xscale);
    }
}
