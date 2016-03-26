/**************************************************
 *
 * log(arg1, arg2, ...)
 * Stringify and log x number of arguments to the console 
 *
 **************************************************/
 
var r = string(argument[0]), i;
for (i = 1; i < argument_count; i++) {
    r += ", " + string(argument[i])
}
show_debug_message(r)
