///mario_update_palette();

/*
**  Name:
**      mario_update_palette();
**
**  Function:
**      Updates the palette to be used on Mario.
*/

//Wrap around the palette to change up Mario's colours.
pal = wrap(isflashing,0,pal_swap_get_pal_count(pal_sprite)-1);

//Set the palette sprite to be used.
switch (global.powerup) {

    //Small, Big, Raccoon
    case (cs_small): 
    case (cs_big): 
    case (cs_leaf): 
        pal_sprite = spr_palette_mario; break;
    
    //Fire
    case (cs_fire):    
        pal_sprite = spr_palette_mario_fire; break;
}
