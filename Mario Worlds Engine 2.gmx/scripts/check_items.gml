///check_items()

/*
**  Usage:
**      check_items()
**
**  Function:
**      Checks if Mario is overlapping a holdable item before shooting anything.
*/

if (!collision_rectangle(bbox_left-3,bbox_top,bbox_right+3,bbox_bottom,obj_holdparent,0,0))
&& (!collision_rectangle(bbox_left-3,bbox_top,bbox_right+3,bbox_bottom,obj_pullparent,0,0))
&& (!collision_rectangle(bbox_left-3,bbox_top-2,bbox_right+3,bbox_bottom+2,obj_throwblock,0,0))
&& (!collision_rectangle(bbox_left,bbox_top-2,bbox_right,bbox_bottom+2,obj_propellerblock,0,0))
&& (!collision_rectangle(bbox_left-3,bbox_top,bbox_right+3,bbox_bottom,obj_bomb,0,0))
&& (!collision_rectangle(bbox_left,bbox_top-2,bbox_right,bbox_bottom+2,obj_mushblock,0,0))
&& (!collision_rectangle(bbox_left,bbox_top-2,bbox_right,bbox_bottom+2,obj_powblock_red,0,0))
    return true;
else
    return false;
