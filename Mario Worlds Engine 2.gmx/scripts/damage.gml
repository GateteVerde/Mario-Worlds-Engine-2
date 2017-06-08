///damage();

/*
**  Name:
**      damage();
**
**  Function:
**      Hurts Mario when called
*/

//If Mario is riding a yoshi.
if (global.yoshi == 1) {

    with (obj_yoshi) {
    
        with (instance_create(x,y,obj_yoshi_runaway)) {
        
            colour = other.colour;
        }
        instance_destroy();
    }
    
    //Make Mario invincible for a while.
    invulnerable = true;
    alarm[0] = 90;
    alarm[1] = 1;
}

//Otherwise, if Mario is NOT riding a yoshi.
else {

    //If health mode is enabled
    if (global.healthmode == true) {
    
        //If Mario does have a powerup.
        if (global.powerup >= cs_fire) {
        
            //Play 'Transform' sound.
            audio_play_sound(snd_transform, 0, false);
        
            //Make Mario invincible for a while.
            invulnerable = true;
            alarm[0] = 90;
            alarm[1] = 1;            
            
            //Turn Mario into Big Mario.
            global.powerup = cs_big;
            
            //Perform animation sequence
            with (instance_create(0,0,obj_mario_transform))
                sequence = 3;            
        }
        else {
    
            //Decrement health
            health--;
            
            //If health is equal to zero.
            if (health == 0) {
            
                //Make Mario die
                instance_create(x,y,obj_mario_dead);
                
                //Destroy
                instance_destroy();
                
                //Exit this event
                exit;
            }
            
            //Otherwise, if health is equal or greater than 1.
            else if (health >= 1) {
            
                //Play 'powerdown' sound.
                audio_play_sound(snd_powerdown, 0, false);
            
                //Make Mario bounce a little.
                hspeed = -2*sign(obj_mario.xscale);
                vspeed = -4;
                
                //Make Mario invincible for a while.
                invulnerable = true;
                alarm[0] = 90;
                alarm[1] = 1;
            }
        }
    }
    
    //Otherwise, if health mode is NOT enabled.
    else if (global.healthmode == false) {
    
        //If Mario has a powerup greater than a mushroom.
        if (global.powerup > cs_big) {
        
            //Play 'Transform' sound.
            audio_play_sound(snd_transform, 0, false);
        
            //Make Mario invincible for a while.
            invulnerable = true;
            alarm[0] = 90;
            alarm[1] = 1;            
            
            //Turn Mario into Big Mario.
            global.powerup = cs_big;
            
            //Perform animation sequence
            with (instance_create(0,0,obj_mario_transform))
                sequence = 3;             
        }
        
        //Otherwise, if Mario is big.
        else if (global.powerup == cs_big) {
        
            //Play 'powerdown' sound.
            audio_play_sound(snd_powerdown, 0, false);
            
            //Drop the reserve item
            with (obj_levelmanager) event_user(0);
        
            //Make Mario invincible for a while.
            invulnerable = true;
            alarm[0] = 90;
            alarm[1] = 1;            
            
            //Turn Mario into Big Mario.
            global.powerup = cs_small;
            
            
            //Perform animation sequence
            with (instance_create(0,0,obj_mario_transform))
                sequence = 1;              
        }
        
        //Otherwise, if Mario is small. 
        else if (global.powerup == cs_small) {
        
            //Make Mario die
            instance_create(x,y,obj_mario_dead);
            
            //Destroy
            instance_destroy();
            
            //Exit this event
            exit;        
        }
    }
}
