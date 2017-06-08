///mario_create();

/*
**  Name:
**      mario_create();
**
**  Function:
**      Calls the variables of the Mario object.
*/

//Handle Mario's current state.
//cs_state_idle:    Idle
//cs_state_walk:    Walk
//cs_state_jump:    Jump / Swim
//cs_state_climb:   Climb
state = cs_state_idle;
statedelay = 0;

//Handle Mario's facing direction.
//1:    Right
//-1:   Left
xscale = 1;

//Handle Mario's direction when stuck on a solid.
//1:    Right
//-1:   Left
direct = 1;

//Handle Mario's climbing style.
//0:    Default climbing
//1:    SMB1 climbing
climbstyle = 0;

//Allow Mario to hang on vines
canhang = 0;

//Allow Mario to turn on vines
canturn = 0;

//Make Mario able to hold various items.
//0:    Can hold
//1:    SMW style holding.
//2:    SMB2 style holding.
holding = 0;

//Handle Mario's jump.
//0:    Can jump
//1:    Can stop in mid-air
//2:    Cannot stop in mid-air
jumping = 0;

//Allow Mario to spin-jump.
spin = false;

//Plays a sound when Mario is climbing up a beanstalk.
noise = 0;

//Makes Mario run faster
run = 0;

//Makes Mario change it's direction.
skidnow = 0;
turning = 0;

//Makes Mario swim when on contact with a water surface.
swimming = 0;

//Makes Mario able to buttslide down slopes.
sliding = 0;

//Makes Mario able to fly high.
flying = false;

//Makes Mario able to crouch down.
duck = 0;

//Handles Mario net smacking
netsmack = false;

//Makes Mario able or not able to move.
move = false;

//Handle P-Meter
pmeter = 0;
pmeterready = false;

//Makes Mario able to kick held items.
kicking = false;

//Is Mario's gravity disabled?
disablegrav = 0;

//Makes Mario invulnerable to all hazards.
invulnerable = false;

//Disables Mario's controls completely.
disablecontrol = false;

//Checks if Mario is stuck on a solid surface.
inwall = false;

//Displays Mario's shooting pose when firing a projectile
firing = 0;

//Displays Mario's special shooting pose when firing a projectile
special = 0;

//Is Raccoon / Tanooki Mario wiggling his tail?
wiggle = 0;

//Handles Mario's combos and gives extra lives.
combo = 0;

//Delay the use of the leaf powerup if Mario just dismounted yoshi
dismount = 0;

//Handle Mario's flashing animation
isflashing = 0;
