///TwoObjectView(object1, object2, view_index)
/*************************************************
 *
 * Forces a view to follow a second object 
 * 
 * Source: http://gmc.yoyogames.com/index.php?showtopic=415796
 *
 * Example (from the first player object):
 * two_object_view(other_player, 0)
 *
 *************************************************/
 
minzoom=1                          // sets the minimal zoom
maxzoom=3                          // sets the maximal zoom

min_wview=room_width/maxzoom        // sets the minimal width of the view
min_hview=room_height/maxzoom       // sets the minimal height of the view
max_wview=room_width/minzoom        // sets the maximal width of the view
max_hview=room_height/minzoom       // sets the maximal height of the view


// calculates the size and position of the view
xdistance=point_distance(argument0.x,0,argument1.x,0)
ydistance=point_distance(0,argument0.y,0,argument1.y)

if xdistance/room_width>ydistance/room_height {
  view_wview[argument2]=xdistance+room_width/4
  
  // Cap view width
  view_wview[argument2] = max(min_wview,view_wview[argument2])
  view_wview[argument2] = min(max_wview,view_wview[argument2])
  
  view_hview[argument2]=view_wview[argument2]/room_width*room_height
} else {
  view_hview[argument2]=ydistance+room_height/4
  
  // Cap view height
  view_hview[argument2] = max(min_hview,view_hview[argument2])
  view_hview[argument2] = min(max_hview,view_hview[argument2])

  view_wview[argument2]=view_hview[argument2]/room_height*room_width
}

view_xview[argument2]=(argument0.x+argument1.x)/2-view_wview[argument2]/2
view_yview[argument2]=(argument0.y+argument1.y)/2-view_hview[argument2]/2

// keeps the view inside the room
if(view_xview[argument2]+view_wview[argument2]>room_width)
  view_xview[argument2]=room_width-view_wview[argument2]

if(view_yview[argument2]+view_hview[argument2]>room_height)
  view_yview[argument2]=room_height-view_hview[argument2]

view_xview[argument2] = max(view_xview[argument2],0)
view_yview[argument2] = max(view_yview[argument2],0)

// Scale the view resolution based on the new size 
surface_resize(application_surface, view_wview[argument2], view_hview[argument2])
