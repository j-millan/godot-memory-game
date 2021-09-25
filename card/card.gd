extends TextureRect

signal flipped_front(card)

var back_texture: Texture = preload('res://assets/card-back.png')
var front_texture: Texture = preload('res://assets/card-front.png')

var texture_path: String = 'res://assets/characters/18.png'
var card_texture: Texture
var texture_size: int = 250

var is_flipped: bool = true
var can_flip: bool = true
var id: int

func _ready():
	connect("gui_input", self, "on_input")
	
	if texture_path:
		card_texture = load(texture_path)
		$Texture.set_texture(card_texture)

func _process(delta):
	pass

func on_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if !is_flipped and can_flip:
			flip()

func flip() -> void:
	var grow = 1.1
	var offset = (Vector2(texture_size, texture_size) - rect_size * grow) / 2
	
	$SizeTween.interpolate_property(self, 'rect_scale', rect_scale, Vector2(grow, grow), 0.1, 
		Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$PositionTween.interpolate_property(self, 'rect_position', rect_position, offset, 0.1,
		Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	
	$SizeTween.start()
	$PositionTween.start()
	yield($SizeTween, "tween_completed")
	
	$SizeTween.interpolate_property(self, 'rect_scale', rect_scale, Vector2(0, grow), 0.2, 
		Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$PositionTween.interpolate_property(self, 'rect_position', rect_position, Vector2(texture_size / 2, offset.y), 0.2,
		Tween.TRANS_LINEAR, Tween.EASE_IN, 0)

	$PositionTween.start()
	$SizeTween.start()
	yield($SizeTween, 'tween_completed')
	
	if is_flipped:
		$Texture.visible = false
		set_texture(back_texture)
		is_flipped = false
	else:
		$Texture.visible = true
		set_texture(front_texture)
		is_flipped = true
		emit_signal("flipped_front", self)
		
	$SizeTween.interpolate_property(self, 'rect_scale', rect_scale, Vector2(grow, grow), 0.2,
		Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$PositionTween.interpolate_property(self, 'rect_position', rect_position, Vector2(0, offset.y), 0.2,
		Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	
	$SizeTween.start()
	$PositionTween.start()
	yield($SizeTween, "tween_completed")
	
	$SizeTween.interpolate_property(self, 'rect_scale', rect_scale, Vector2(1, 1), 0.1, 
		Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$PositionTween.interpolate_property(self, 'rect_position', rect_position, Vector2.ZERO, 0.1,
		Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	
	$SizeTween.start()
	$PositionTween.start()

func highlight() -> void:
	var grow = 1.1
	var offset = (Vector2(texture_size, texture_size) - rect_size * grow) / 2
	
	$SizeTween.interpolate_property(self, 'rect_scale', rect_scale, Vector2(grow, grow), 0.3, 
		Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$PositionTween.interpolate_property(self, 'rect_position', rect_position, offset, 0.3,
		Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	
	$SizeTween.start()
	$PositionTween.start()
	yield($SizeTween, "tween_completed")
	
	$SizeTween.interpolate_property(self, 'rect_scale', rect_scale, Vector2(1, 1), 0.3, 
		Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$PositionTween.interpolate_property(self, 'rect_position', rect_position, Vector2.ZERO, 0.3,
		Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	
	$SizeTween.start()
	$PositionTween.start()
