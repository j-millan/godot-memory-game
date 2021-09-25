extends CanvasLayer

var card_scene: PackedScene = preload("res://card/card.tscn")

var textures_file_path: String = "res://assets/textures.json"
var possible_textures: Array

var flipped_card: TextureRect
var can_flip: bool = true

func _ready():
	randomize()
	get_possible_textures()
	add_cards()
	
	$FlipCooldown.connect("timeout", self, "flip_timeout")

func _process(delta):
	pass

func flip_timeout() -> void:
	for card in get_tree().get_nodes_in_group('cards'):
		card.can_flip = true
		
	can_flip = true

func card_flipped(card: TextureRect) -> void:
	if can_flip:
		can_flip = false
		
		for card in get_tree().get_nodes_in_group('cards'):
			card.can_flip = false
		
		if !flipped_card:
			flipped_card = card
		else:
			if !flipped_card.id == card.id:
				yield(get_tree().create_timer(1), "timeout")
				card.flip()
				flipped_card.flip()
			else:
				yield(get_tree().create_timer(0.7), "timeout")
				card.highlight()
				flipped_card.highlight()
			
			flipped_card = null
		
		$FlipCooldown.start()
	
	check_cards()

func check_cards() -> void:
	for card in get_tree().get_nodes_in_group('cards'):
		if !card.is_flipped:
			return
	
	for card in get_tree().get_nodes_in_group('cards'):
		card.highlight()
	
	yield(get_tree().create_timer(2), "timeout")
	
	for card in get_tree().get_nodes_in_group('cards'):
		card.free()
	
	get_possible_textures()
	add_cards()
	can_flip = true

func get_possible_textures() -> void:
	var file = File.new()
	file.open(textures_file_path, File.READ)
	var content = file.get_as_text()
	possible_textures = JSON.parse(content).result
	file.close()
	
	possible_textures.shuffle()
func add_cards():
	possible_textures = possible_textures.slice(0, 7)
	for item in possible_textures:
		var index = possible_textures.find(item)
		for i in range(2):
			var free_slots = get_free_slots()
			var slot = free_slots[randi() % free_slots.size()]
			var new_card = card_scene.instance()
			
			new_card.texture_path = item.path
			new_card.id = index
			new_card.connect("flipped_front", self, "card_flipped")
			slot.add_child(new_card)
	
	yield(get_tree().create_timer(2), "timeout")
	
	for card in get_tree().get_nodes_in_group('cards'):
		card.flip()

func get_free_slots() -> Array:
	var free_slots: Array = []
	
	for slot in get_tree().get_nodes_in_group('slots'):
		if !slot.has_node('Card'):
			free_slots.append(slot)
	
	return free_slots
