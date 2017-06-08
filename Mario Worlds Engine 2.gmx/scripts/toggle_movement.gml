///toggle_movement();

/*
**  Usage:
**      toggle_movement();
**
**  Purpose:
**      Enables / Disables Mario's horizontal movement when certain conditions are true.
*/

if (duck) { //If Mario is crouched down.

    if (state == cs_state_jump) { //If Mario is jumping.
    
        //Allow Mario's horizontal movement.
        move = true;
    }
    else { //Otherwise, disallow Mario's movement.
    
        //Disallow Mario's horizontal movement.
        move = false;    
    }
}
else { //If Mario is not crouched down.

    move = true;
}
