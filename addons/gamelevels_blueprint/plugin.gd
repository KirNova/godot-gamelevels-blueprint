@tool
extends EditorPlugin

const icon = preload("res://addons/gamelevels_blueprint/icons/compass-svgrepo-com.svg")

const Dock = preload("res://addons/gamelevels_blueprint/ui/dock.tscn")

var dock_instance

func _enter_tree():
	dock_instance = Dock.instantiate()
	# Add the main panel to the editor's main viewport.
	get_editor_interface().get_editor_main_screen().add_child(dock_instance)
	# Hide the main panel. Very much required.
	_make_visible(false)
	# para permitir acceder al editor interface
	get_tree().set_meta("editor_interface", get_editor_interface())


func _exit_tree():
	if dock_instance:
		dock_instance.queue_free()

func _has_main_screen():
	return true

func _make_visible(visible):
	if dock_instance:
		dock_instance.visible = visible

func _get_plugin_name():
	return "LvlMap"

func _get_plugin_icon():
	return icon
