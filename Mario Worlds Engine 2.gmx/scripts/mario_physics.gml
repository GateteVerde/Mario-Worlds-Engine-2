#define mario_physics
///mario_physics();

/*
**  Name:
**      mario_physics();
**
**  Function:
**      Updates the physics to be used on Mario.
*/

//Dismount
if (dismount > 0)
    dismount--;

//Floor collision
mario_physics_floor();

//If Mario is bumping into a wall or a holdable object to the right.
if (hspeed > 0) {

    //If there's a wall on the way.
    if (collision_rectangle(bbox_right,bbox_top+4,bbox_right+1,bbox_bottom-4,obj_solid,1,0)) {
    
        //Stop Mario's horizontal speed.
        hspeed = 0;
        
        //Prevent Mario from getting embed into the wall.
        while (collision_rectangle(x,bbox_top+4,bbox_right,bbox_bottom-1,obj_solid,1,0))
        && (!collision_point(x,bbox_top+4,obj_solid,0,0))
            x--;
    }
    
    //If there's a wall on the way.
    else if (collision_rectangle(bbox_right,bbox_top+4,bbox_right+1,bbox_bottom-4,obj_platformparent_solid,1,0)) {
    
        //Stop Mario's horizontal speed.
        hspeed = 0;
        
        //Prevent Mario from getting embed into the wall.
        while (collision_rectangle(x,bbox_top+4,bbox_right,bbox_bottom-1,obj_platformparent_solid,1,0))
        && (!collision_point(x,bbox_top+4,obj_platformparent_solid,0,0))
            x--;
    }
}

//If Mario is bumping into a wall or a holdable object to the left.
else if (hspeed < 0) { 

    //If there's a wall on the way.
    if (collision_rectangle(bbox_left-1,bbox_top+4,bbox_left,bbox_bottom-4,obj_solid,1,0)) {
    
        //Stop Mario's horizontal speed.
        hspeed = 0;
        
        //Prevent Mario from getting embed into the wall.
        while (collision_rectangle(bbox_left,bbox_top+4,x,bbox_bottom-1,obj_solid,1,0))
        && (!collision_point(x,bbox_top+4,obj_solid,0,0))
            x++;
    }
    
    //If there's a wall on the way.
    else if (collision_rectangle(bbox_left-1,bbox_top+4,bbox_left,bbox_bottom-4,obj_platformparent_solid,1,0)) {
    
        //Stop Mario's horizontal speed.
        hspeed = 0;
        
        //Prevent Mario from getting embed into the wall.
        while (collision_rectangle(bbox_left,bbox_top+4,x,bbox_bottom-1,obj_platformparent_solid,1,0))
        && (!collision_point(x,bbox_top+4,obj_platformparent_solid,0,0))
            x++;
    }
}

//If Mario's is moving up.
if (vspeed < 0) {

    //If there's a solid on the way.
    if (collision_rectangle(bbox_left,bbox_top,bbox_right,bbox_top,obj_solid,1,0)) 
    || (collision_rectangle(bbox_left,bbox_top,bbox_right,bbox_top,obj_platformparent_solid,1,0)) {

        //Check if there's a block on the way.
        var block = collision_rectangle(bbox_left,bbox_top-2,bbox_right,bbox_top,obj_blockparent,0,0);
        
        //If there's a block on the way.
        if (block) {
            
            //If the block has NOT been hit.
            if (block.ready == 0) {
        
                //Trigger block events
                with (block) {
                
                    //Block is hit
                    ready = 1;
                    
                    //Set vertical speed
                    vspeed = -2;
                    alarm[0] = 4;
                    
                    //Block specific events
                    event_user(0);
                }
            }
        }
        
        //Stop vertical movement
        vspeed = 0;
        
        //If Mario is not climbing
        if ((state == cs_state_jump) && (state != cs_state_climb)) {
        
            //Stop variable jumping
            jumping = 2;
            
            //Play 'Bump' sound
            if (!audio_is_playing(snd_bump))
                audio_play_sound(snd_bump, 0, false);
        }
    }
}

//Prevent Mario's head from getting embed in the ceiling.
if ((state == cs_state_jump) || (statedelay > 0)) {

    ceiling = collision_rectangle(bbox_left,bbox_top-1,bbox_right,bbox_top,obj_solid,1,0);
    if (ceiling)
    && (ceiling.sprite_index != spr_square)
        y++;
}

//If Mario is not climbing.
if (state != cs_state_climb) {

    //If Mario's controls are disabled and he's not jumping.
    if ((state != cs_state_jump) && (!disablecontrol)) {
    
        //Make Mario crouch down.
        if (keyboard_check(vk_down))
        && (canduck)        
        && (!duck)
        && (!sliding)
        && (instance_number(obj_tounge) == 0) {
        
            if (swimming)
            || (!collision_rectangle(x-1,bbox_bottom,x+1,bbox_bottom+1,obj_slopeparent,1,0))
                duck = true;
        }
            
        //Stops Mario from crouching down.
        else if ((!keyboard_check(vk_down)) && (duck)) {
        
            //Stop Mario from crouching down.
            duck = false
            
            //If there's a ceiling above Mario after getting up, make him move until it's not embed on a solid.
            if (collision_rectangle(bbox_left,bbox_top-16,bbox_right,bbox_top-16,obj_solid,1,0))
            && (global.powerup != cs_small)
                inwall = true;
        }
    }
    
    //Handles powerup specific projectiles.
    if (keyboard_check_pressed(vk_control))
    && (duck == 0)
    && (holding == 0)
    && (sliding == 0)
    && (check_items())
    && (!obj_levelmanager.barrier)
        alarm[7] = 1;
}
else {

    //Stop Mario from crouching down
    duck = false;
    
    //Disable the spin jump kill ability.
    spin = false;
}

//Make Mario swim.
var water = collision_rectangle(bbox_left,bbox_top,bbox_right,bbox_top,obj_swim,0,0);
var water_alt = collision_rectangle(bbox_left,bbox_top,bbox_right,bbox_top,obj_swim_alt,0,0); 

//If Mario can swim
if (canswim) {

    //If Mario is not swimming and makes contact with a water surface.
    if ((!swimming) && ((water) || (water_alt))) {
    
        //Create a splash effect.
        with (instance_create(x-8,water.y,obj_smoke)) {
        
            //Set the sprite.
            sprite_index = spr_smoke_splash;
            
            //Set the animation speed
            image_speed = 0.2;
            
            //Set the vertical speed
            vspeed = -2;
            gravity = 0.1;
        }
            
        //Make Mario swim.
        swimming = true;
        
        //Make Mario stop sliding
        sliding = false;
        
        //Make Mario get up
        duck = false;
        
        //Make Mario stop spin
        spin = false;
        
        //Stop horizontal movement
        hspeed = 0;
        
        //Stop vertical movement
        gravity = 0;
        if (vspeed > 0)
            vspeed = 0;
    }
    
    //If Mario had enough swimming and wants to get out.
    else if ((swimming) && ((!water) && (!water_alt))) {
    
        //If there's not water above and there's not a solid on the way out.
        if (!collision_rectangle(bbox_left,bbox_top-1,bbox_right,bbox_top-1,obj_solid,0,0)) {
        
            //If Mario is swimming and moving up.
            if ((state == cs_state_jump) && (vspeed < 0)) {
            
                //If 'Shift' is held.
                if (keyboard_check(vk_shift)) {
                
                    //Create a splash effect.
                    with (instance_create(x-8,y-1,obj_smoke)) {
                    
                        //Set the sprite.
                        sprite_index = spr_smoke_splash;
                        
                        //Set the animation speed
                        image_speed = 0.2;
                        
                        //Set the vertical speed
                        vspeed = -2;
                        gravity = 0.1;
                    }
                    
                    //Make Mario not swim
                    swimming = false;
                    
                    //Allow variable jump
                    jumping = 1;
                    
                    //Set the vertical speed.
                    vspeed = -3.4675;
                }
                
                //Otherwise, if 'Shift' is not held.
                else {
                
                    //If Mario is moving up.
                    if (vspeed < 0) {
                    
                        //Stop vertical movement
                        vspeed = 0;
                    }
                }
            }
        }
    }
}

//Free Mario is he is stuck on a solid.
if (state <= cs_state_walk) 
&& (!duck) 
&& (!inwall)
&& (!collision_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,obj_mushblock,0,1)) {

    //Check for a nearby solid block.
    var stuck = collision_rectangle(bbox_left,bbox_top,bbox_right,bbox_top,obj_solid,1,1);
    
    //If Mario is embed on a wall and it's not overlapping a mushblock.
    if (stuck) {
    
        //If Mario is colliding with a left or right modifier.
        if (!collision_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,obj_left,0,0))
        && (!collision_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,obj_right,0,0)) {
        
            //If Mario is facing right.
            if (xscale == 1) {
            
                //If Mario's horizontal speed is equal/greater than 0.
                if (hspeed >= 0) {
            
                    //Move mario to safety.
                    inwall = true;
                    
                    //Set the direction to move.
                    direct = -1;
                }
                
                //Otherwise, if Mario's horizontal speed is lower than 0.
                else if (hspeed < 0) {
                
                    //Move mario to safety.
                    inwall = true;
                    
                    //Set the direction to move.
                    direct = 1;                
                }
            }
            
            //Otherwise, if Mario is facing left.
            else if (xscale == -1) {
            
                //If Mario's horizontal speed if equal/lower than 0.
                if (hspeed <= 0) {
            
                    //Move mario to safety.
                    inwall = true;
                    
                    //Set the direction to move.
                    direct = 1;
                }
                
                //Otherwise, if Mario's horizontal speed if greater than 0.
                else if (hspeed > 0) {
                
                    //Move mario to safety.
                    inwall = true;
                    
                    //Set the direction to move.
                    direct = -1;                
                }           
            }
        }
        
        //Otherwise, if Mario is overlapping an left modifier.
        else if (collision_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,obj_left,0,0)) {
        
            //Move mario to safety.
            inwall = true;
            
            //Set the direction to move.
            direct = -1;              
        }
        
        //Otherwise, if Mario is overlapping an right modifier.
        else if (collision_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,obj_right,0,0)) {
        
            //Move mario to safety.
            inwall = true;
            
            //Set the direction to move.
            direct = 1;              
        }
    }
}

//Otherwise, if Mario gets stuck on a wall.
else if (inwall) {

    //Move Mario until it's not embed in a wall.
    x += 1*sign(direct);
    
    //If Mario is not longer embed on a wall, make him able to move.
    if (!collision_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,obj_solid,1,0))
        inwall = false;
}

//Handle tail whip animation
if ((state == cs_state_jump) && (wiggle > 0))
    wiggle--;
else
    wiggle = 0;
    
//If Mario is not in contact with water.
if (!collision_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,obj_swim,1,1)) 
&& (!collision_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,obj_swim_alt,1,1)) {

    //If the player is swimming.
    if (swimming)  
        swimming = false;
}

//Prevent Mario from going too high on the level
if (y < -96)
    y = -96;
    
//Make Mario die if he falls on a pit.
else if (bbox_top > room_height+32) {

    instance_create(x,y,obj_mario_dead);
    instance_destroy();
    exit;
}

#define mario_physics_floor
///mario_physics_floor();

/*
**  Name:
**      mario_physics_floor();
**
**  Function:
**      Handles collision with the floor, slopes, etc.
*/

//Floor collision
if (vspeed >= 0) { //If Mario is moving down.

    //Check for a nearby semisolid platform.
    var semisolid = collision_rectangle(bbox_left,bbox_bottom,bbox_right,bbox_bottom+1+vspeed,obj_semisolid,0,0);
    
    //If Mario is above a semisolid platform.
    if ((semisolid) && (bbox_bottom < semisolid.yprevious+5)) {
    
        //Snap above the platform.
        y = semisolid.y-16;
        
        //Stop vertical movement.
        vspeed = 0;
        gravity = 0;

        //Reset values
        event_user(15);
    }
    
    //Check for a nearby semisolid platform.
    var semisolid_moving = collision_rectangle(bbox_left,bbox_bottom,bbox_right,bbox_bottom+1+vspeed,obj_platformparent,0,0);
    
    //If Mario is above a semisolid platform.
    if ((semisolid_moving) && (bbox_bottom < semisolid_moving.yprevious+5)) {
    
        //Snap above the platform.
        y = semisolid_moving.y-16;
        
        //Stop vertical movement.
        vspeed = 0;
        gravity = 0;
        
        //Reset values
        event_user(15);
    }
}

//Embed Mario into the slope if he is walking or sliding down a slope to ensure correct slope physics.
if (collision_rectangle(x-1,bbox_bottom+1,x+1,bbox_bottom+5,obj_slopeparent,1,0)) 
&& (!collision_rectangle(x-1,bbox_bottom-4,x+1,bbox_bottom-4,obj_slopeparent,1,0))
&& (state <= cs_state_walk)
    y += 4;

//Handle Slope collision
if (collision_rectangle(x-1,bbox_bottom-4,x+1,bbox_bottom,obj_slopeparent,1,0)) 
&& (!collision_rectangle(x-1,bbox_bottom-8,x+1,bbox_bottom-8,obj_slopeparent,1,0)) {

    //If Mario is moving down onto a slope.
    if (vspeed >= 0) {
    
        //Stop vertical movement
        vspeed = 0;
        gravity = 0;
        
        //Reset values
        event_user(15);
    }
    
    //Prevent Mario from getting embed inside a slope.
    if (vspeed > -0.8) {
    
        while (collision_rectangle(x-1,bbox_bottom-4,x+1,bbox_bottom,obj_slopeparent,1,0))
            y--;
    }
}

//Embed Mario into a platform slope if he is walking to ensure correct slope physics.
if (collision_rectangle(x-1,bbox_bottom+1,x+1,bbox_bottom+5,obj_platformparent_slope,1,0)) 
&& (!collision_rectangle(x-1,bbox_bottom-4,x+1,bbox_bottom-4,obj_platformparent_slope,1,0))
&& (state <= cs_state_walk)
    y += 4;

//Handle platform slope collision
if (collision_rectangle(x-1,bbox_bottom-4,x+1,bbox_bottom,obj_platformparent_slope,1,0)) 
&& (!collision_rectangle(x-1,bbox_bottom-8,x+1,bbox_bottom-8,obj_platformparent_slope,1,0)) {

    //If Mario is moving down onto a slope.
    if (vspeed >= 0) {
    
        //Stop vertical movement
        vspeed = 0;
        gravity = 0;
        
        //Reset values
        event_user(15);
    }
    
    //Prevent Mario from getting embed inside a slope.
    if (vspeed > -0.85) {
    
        while (collision_rectangle(x-1,bbox_bottom-4,x+1,bbox_bottom,obj_platformparent_slope,1,0))
            y--;
    }
}