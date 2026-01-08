@tool

extends Popup

##TODO desactivar todo (menos el boton de eliminar) cuando el archivo no exista

var _room_panel_to_edit : Object

var _dragging := false
var _drag_start_pos := Vector2.ZERO

func _ready() -> void:
	# Enable mouse input handling on the panel
	$Panel.mouse_filter = Control.MOUSE_FILTER_STOP
	$Panel.gui_input.connect(_on_Panel_gui_input)

func _on_Panel_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				_dragging = true
				_drag_start_pos = event.position
			else:
				_dragging = false
	
	elif event is InputEventMouseMotion and _dragging:
		var current_pos = $Panel.position
		$Panel.position = current_pos + (event.position - _drag_start_pos)

func show_form() -> void:
	popup_centered()

func hide_form() -> void:
	_room_panel_to_edit = null
	visible = false


func set_data(room_panel:Object) -> void:
	_room_panel_to_edit = room_panel
	$Panel/Margin/VBx/HBxFilePath/HBx/TxtFilePath.text = room_panel.file_path
	$Panel/Margin/VBx/HBxDescription/TextEdit.text = room_panel.description
	## seleccionar el color establecido
	## seleccionar el color establecido
	var checkbox = _get_color_checkbox(room_panel.color_panel)
	if checkbox:
		checkbox.button_pressed = true
	else:
		# Fallback to first color if match failed
		var first_color = $Panel/Margin/VBx/HBxColors/Colors.get_child(0)
		if first_color:
			first_color.button_pressed = true
	
	#print(room_panel.icons)
	for icn_check in get_node("%ChecksIcons").get_children():
		if room_panel.icons.keys().has(icn_check.name):
			var is_pressed = room_panel.icons[icn_check.name]
			if is_pressed is bool:
				icn_check.button_pressed = is_pressed
			else:
				icn_check.button_pressed = false
		else:
			icn_check.button_pressed = false

## se presiono el check de icono
#func _on_CheckIcon_toggled(pressed:bool, name_check:String) -> void:
#	pass

## obtener el check que coincida con el color
func _get_color_checkbox(clr:Color) -> Object:
	for c in $Panel/Margin/VBx/HBxColors/Colors.get_children():
		if c.color == clr:
			return c
	return null

## obtener el checkbox de color presionado
func _get_pressed_color_checkbox() -> Object:
	for c in $Panel/Margin/VBx/HBxColors/Colors.get_children():
		if c.button_pressed == true:
			return c
	return null

func _on_FormSceneData_pressed() -> void:
	
	if $FileDialog.visible == true:
		return
	
	hide_form()


func _on_BtnExplore_pressed() -> void:
	if _room_panel_to_edit != null:
		$FileDialog.set_current_path(_room_panel_to_edit.file_path)
	$FileDialog.popup()


func _on_FileDialog_file_selected(path: String) -> void:
	$Panel/Margin/VBx/HBxFilePath/HBx/TxtFilePath.text = path


func _on_BtnClose_pressed() -> void:
	hide_form()


func _on_BtnDelete_pressed() -> void:
	if _room_panel_to_edit != null:
		_room_panel_to_edit.queue_free()
	hide_form()


func _on_BtnSave_pressed() -> void:
	if _room_panel_to_edit != null:
		
		_room_panel_to_edit.file_path = $Panel/Margin/VBx/HBxFilePath/HBx/TxtFilePath.text
		var pressed_checkbox = _get_pressed_color_checkbox()
		if pressed_checkbox:
			_room_panel_to_edit.color_panel = pressed_checkbox.color
		else:
			# Keep old color or default if nothing selected
			pass
		_room_panel_to_edit.description = $Panel/Margin/VBx/HBxDescription/TextEdit.text
		
		for icn in get_node("%ChecksIcons").get_children():
			_room_panel_to_edit.icons[icn.name] = get_node("%ChecksIcons/"+icn.name).button_pressed
		
		_room_panel_to_edit.update_data()
	
	hide_form()
