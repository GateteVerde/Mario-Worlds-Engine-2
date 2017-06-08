///mario_run();

/*
**  Usage:
**      mario_run();
**
**  Purpose:
**      Makes Mario run faster and allows him to do special abilities.
*/

//If Mario's horizontal speed is equal/greater than 2.7 and it's not wearing a kuribo shoe.
if (abs(hspeed) >= 2.5) {

    //If Mario is not jumping.
    if (state < cs_state_jump) {
    
        //If the P-Meter is full.
        if (pmeter > 112) {
            
            //Keep P-Meter full.
            pmeter = 112;
        
            //Make Mario able to run.
            run = true;
        }
        else {
        
            //Fill P-Meter.
            pmeter += 2;
        }
    }
    
    //If Mario is on the ground and not running.
    else if ((!run) && (pmeter > 0))
        pmeter--;
}

//Otherwise, if Mario's horizontal speed is lower than 2.7.
else if ((!run) || ((state <= cs_state_walk) && (abs(hspeed) < 2.5))) { 

    //If Mario is flying and lands on the floor.
    if (flying) {
        
        //Allow Mario to fly again.
        flying = false;
        
        //Make Mario walk
        run = false;
        
        //Empty P-Meter.
        if (pmeter > 0)        
            pmeter --;
    }
    
    //If Mario is not flying.
    else if (!flying) {
        
        //Make Mario walk
        run = false;
        
        //Restart flying.
        alarm[9] = 0;
        
        //Empty P-Meter.
        if (pmeter > 0)       
            pmeter --;
    }   
}
