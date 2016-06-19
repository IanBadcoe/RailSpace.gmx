#define Map

#define map_begin_drag
_mouse_start_x = window_mouse_get_x();
_mouse_start_y = window_mouse_get_y();
_in_drag = true;
_view_start_x = view_xview[0];
_view_start_y = view_yview[0];