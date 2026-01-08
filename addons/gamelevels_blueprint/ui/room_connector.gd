@tool

extends GraphNode

@export var node_a_path := NodePath()
@export var node_b_path := NodePath()

var node_a : Object = null
var node_b : Object = null

var _btn_disconnect_hovered : bool

var _original_line_color := Color("#ffffff85")

func _ready() -> void:

	$Line2D.default_color = _original_line_color
	
	## mover al inicio  del tree parent
	get_parent().call_deferred("move_child", self, 0)
	
	make_connections()
	
	_update_line()

func make_connections() -> void:
	
	node_a = get_node_or_null(node_a_path)
	node_b = get_node_or_null(node_b_path)

	## conectar señales que indican que el panel se está moviendo
	
	if node_a != null and node_a.has_signal("position_offset_changed"):
		node_a.connect("tree_exiting", Callable(self, "_on_RoomPanel_tree_exiting"))
		node_a.connect("position_offset_changed", Callable(self, "_on_RoomPanel_offset_changed"))
		node_a.connect("focus_entered", Callable(self, "_on_RoomPanel_focus_entered"))
		node_a.connect("focus_exited", Callable(self, "_on_RoomPanel_focus_exited"))
	
	if node_b != null and node_b.has_signal("position_offset_changed"):
		node_b.connect("tree_exiting", Callable(self, "_on_RoomPanel_tree_exiting"))
		node_b.connect("position_offset_changed", Callable(self, "_on_RoomPanel_offset_changed"))
		node_b.connect("focus_entered", Callable(self, "_on_RoomPanel_focus_entered"))
		node_b.connect("focus_exited", Callable(self, "_on_RoomPanel_focus_exited"))

func focus_line() -> void:
	_original_line_color = $Line2D.default_color
	$Line2D.default_color = Color("16c4c8")
	$Line2D.width = 8
	$BtnDisconnect.disabled = false
	self_modulate.a = 1
	$BtnDisconnect.self_modulate.a = 1

func unfocus_line() -> void:
	$Line2D.default_color = Color("#ffffff85")
	$Line2D.width = 4
	$BtnDisconnect.disabled = true
	self_modulate.a = 0
	$BtnDisconnect.self_modulate.a = 0

func _update_line() -> void:
	if node_a == null or node_b == null:
		return
	
	var point_a : Vector2 = node_a.get_center_offset()
	var point_b : Vector2 = node_b.get_center_offset()

	## posicionar al centro de la linea
	position_offset = Vector2(
		( (point_a.x + point_b.x) / 2 ),
		( (point_a.y + point_b.y) / 2 )
	)
	position_offset = position_offset - (size / 2)

	$Line2D.points[0] = point_a - position_offset
	$Line2D.points[1] = point_b - position_offset

func _on_RoomPanel_tree_exiting() -> void:
	queue_free()

func _on_RoomPanel_offset_changed() -> void:
	_update_line()



func _on_BtnDisconnect_pressed() -> void:
	queue_free()

func _on_RoomPanel_focus_entered() -> void:
	focus_line()

func _on_RoomPanel_focus_exited() -> void:
	## si el mouse esta encima de boton desconectar
	## no hacer nada, para evitar desaparecer el boton al hacer click
	## en el boton desconectar
	if _btn_disconnect_hovered:
		return
	unfocus_line()

func _on_BtnDisconnect_mouse_entered() -> void:
	_btn_disconnect_hovered = true
	_original_line_color = $Line2D.default_color
	$Line2D.default_color = Color("b41212")

func _on_BtnDisconnect_mouse_exited() -> void:
	_btn_disconnect_hovered = false
	$Line2D.default_color = _original_line_color
