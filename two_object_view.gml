///two_object_view(object_to_follow, view_index)
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
xdistance=point_distance(x,0,argument0.x,0)
ydistance=point_distance(0,y,0,argument0.y)

if xdistance/room_width>ydistance/room_height {
  view_wview[argument1]=xdistance+room_width/4
  
  // Cap view width
  view_wview[argument1] = max(min_wview,view_wview[argument1])
  view_wview[argument1] = min(max_wview,view_wview[argument1])
  
  view_hview[argument1]=view_wview[argument1]/room_width*room_height
} else {
  view_hview[argument1]=ydistance+room_height/4
  
  // Cap view height
  view_hview[argument1] = max(min_hview,view_hview[argument1])
  view_hview[argument1] = min(max_hview,view_hview[argument1])

  view_wview[argument1]=view_hview[argument1]/room_height*room_width
}

view_xview[argument1]=(x+argument0.x)/2-view_wview[argument1]/2
view_yview[argument1]=(y+argument0.y)/2-view_hview[argument1]/2

// keeps the view inside the room
if(view_xview[argument1]+view_wview[argument1]>room_width)
  view_xview[argument1]=room_width-view_wview[argument1]

if(view_yview[argument1]+view_hview[argument1]>room_height)
  view_yview[argument1]=room_height-view_hview[argument1]

view_xview[argument1] = max(view_xview[argument1],0)
view_yview[argument1] = max(view_yview[argument1],0)

// Scale the view resolution based on the new size 
surface_resize(application_surface, view_wview[argument1], view_hview[argument1])
