/***************************************************
 * two_object_view
 *
 * Resize a view to always keep two objects in the viewport
 * Source: daman123125
 * 
 * Example (use in step)
 * two_object_view(otherobject,viewnumber)
 *
***************************************************/

//sets the height of the view to the distance to the second object times 1.5 plus 150
view_hview[argument1]=(distance_to_object(argument0)*1.5)+150 

//sets the width of the view to the distance to the second object times 2 plus 180
view_wview[argument1]=(distance_to_object(argument0)*2)+180 

//sets the x position of the view
view_xview[argument1]=((x+argument0.x)/2)-(view_wview[argument1]/2)

// sets the y position of the view
view_yview[argument1]=((y+argument0.y)/2)-(view_hview[argument1]/2)
