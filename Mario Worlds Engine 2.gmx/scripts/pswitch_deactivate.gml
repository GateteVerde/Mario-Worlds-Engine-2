///pswitch_deactivate();

/*
**  Usage:
**      pswitch_deactivate();
**
**  Function:
**      Turns off the P-Switch effect
*/

//Turn bricks into coins.
with (obj_brick) {

    //Create a coin from the brick.
    instance_create(x,y,obj_coinchange);
    
    //Destroy the brick
    instance_destroy();
}

//Turn coins into bricks.
with (obj_coin) {

    //Create a brick from the coin.
    instance_create(x,y,obj_brick);
    
    //Destroy the brick.
    instance_destroy();
}

//Turn fake coins into coins.
with (obj_coinchange) {

    //Create a coin from the fake coin.
    instance_create(x,y,obj_coin);

    //Destroy the brick
    instance_destroy();    
}

//Make visible coins invisible
with (obj_coin_hidden) event_user(0);

//Make P-Switch doors active
with (obj_door_p) visible = false;
