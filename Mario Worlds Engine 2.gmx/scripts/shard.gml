///shard(x,y,sprite,dir)

/*
**  Usage:
**      shard(x,y,sprite,dir)
**
**  Returns:
**      Creates various shards with the given sprite on argument[2].
*/

with (instance_create(argument[0],argument[1],obj_shard)) {

    sprite_index = argument[2];
    motion_set(argument[3],6);
}
