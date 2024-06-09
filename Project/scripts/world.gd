extends Node2D

@onready var tile_map = $TileMap
@onready var camera_2d = $Player/Camera2D


@onready var seed1_sound = $sound_effects/seed
@onready var dirt_sound = $sound_effects/dirt
@onready var seed2_sound = $sound_effects/seed2
@onready var seed3_sound = $sound_effects/seed3
#@onready var mainmenu = preload("res://main menu/main_menu.tscn") as PackedScene


# relevant layer variables
var ground_layer = 1
var environment_layer = 2

# choose where you want seed to be placed or not (TileMap -> custom data layers)
var can_place_seed_custom_data = "can_place_seeds"
var can_place_dirt_custom_data = "can_place_dirt"

enum FARMING_MODE {SEED1, SEED2, SEED3, DIRT}

var farming_mode_state = FARMING_MODE.DIRT

var dirt_tiles = []





func _input(_event):
	#if Input.is_action_just_pressed("main_menu"):
		#get_tree().change_scene_to_packed(mainmenu)
	if Input.is_action_just_pressed("zoom_in"):
		var zoom_val = camera_2d.zoom.x + 0.1
		if zoom_val > 7:
			return
			#zoom_val = camera_2d.zoom.x - 0.1
		#print(zoom_val)
		camera_2d.zoom = Vector2(zoom_val, zoom_val)
	if Input.is_action_just_pressed("zoom_out"):
		var zoom_val = camera_2d.zoom.x - 0.1
		if zoom_val < 2:
			return
			#zoom_val = camera_2d.zoom.x + 0.1
		#print(zoom_val)
		camera_2d.zoom = Vector2(zoom_val, zoom_val)
	if Input.is_action_just_pressed("toggle_dirt"):
		farming_mode_state = FARMING_MODE.DIRT
		print("Dirt")
	if Input.is_action_just_pressed("toggle_seed1"):
		farming_mode_state = FARMING_MODE.SEED1
		print("Seed_1")
	if Input.is_action_just_pressed("toggle_seed2"):
		farming_mode_state = FARMING_MODE.SEED2
		print("Seed_2")
	if Input.is_action_just_pressed("toggle_seed3"):
		farming_mode_state = FARMING_MODE.SEED3
		print("Seed_3")
	if Input.is_action_just_pressed("click"):
		
		# calls for global x,y mouse position
		var mouse_pos : Vector2 = get_global_mouse_position()
		
		
#		print("global mouse position", mouse_pos)
		
		# converts global x,y mouse pos into int
		var tile_mouse_pos = tile_map.local_to_map(mouse_pos) 
		
#		print("tile mouse position", tile_mouse_pos)
		
		
				
		
		if farming_mode_state == FARMING_MODE.SEED1:
			# choosing the seed from the tile map by its coords on this variable
			var atlas_coord : Vector2i = Vector2i(11,1)
			#var atlas_coord = [Vector2i(11,1), Vector2i(12,1)]
			if retrieving_custom_data(tile_mouse_pos, can_place_seed_custom_data, ground_layer):
				#tile_map.set_cell(environment_layer, tile_mouse_pos, source_id, atlas_coord)
				var level : int = 0
				var final_seed1_level : int = 3
				handle_seed(tile_mouse_pos, level, atlas_coord, 0, final_seed1_level,1,1)
				seed1_sound.play()
		elif farming_mode_state == FARMING_MODE.SEED2:
			# choosing the seed from the tile map by its coords on this variable
			var atlas_coord2 : Vector2i = Vector2i(0,0)
			#var atlas_coord = [Vector2i(11,1), Vector2i(12,1)]
			if retrieving_custom_data(tile_mouse_pos, can_place_seed_custom_data, ground_layer):
				#tile_map.set_cell(environment_layer, tile_mouse_pos, source_id, atlas_coord)
				var level : int = 0
				var final_seed2_level : int = 2
				handle_seed(tile_mouse_pos, level, atlas_coord2, 2, final_seed2_level,1, 2)
				seed2_sound.play()
		elif farming_mode_state == FARMING_MODE.SEED3:
			# choosing the seed from the tile map by its coords on this variable
			var atlas_coord3 : Vector2i = Vector2i(6,0)
			#var atlas_coord = [Vector2i(11,1), Vector2i(12,1)]
			if retrieving_custom_data(tile_mouse_pos, can_place_seed_custom_data, ground_layer):
				#tile_map.set_cell(environment_layer, tile_mouse_pos, source_id, atlas_coord)
				var level : int = 0
				var final_seed3_level : int = 2
				handle_seed(tile_mouse_pos, level, atlas_coord3, 2, final_seed3_level,1, 2)
				seed3_sound.play()
		elif farming_mode_state == FARMING_MODE.DIRT:
			if retrieving_custom_data(tile_mouse_pos, can_place_dirt_custom_data, ground_layer):
				dirt_tiles.append(tile_mouse_pos)
				
				# connects terrains and automatically fixes their placement as best as it fits from the TileSet
				# Terrain set 2, Terrain 0 (dirt_on_grass)
				tile_map.set_cells_terrain_connect(ground_layer, dirt_tiles, 2, 0)
				dirt_sound.play()
		
# general function for retrieving custom data
func retrieving_custom_data(tile_mouse_pos, custom_data_layer, layer):
	var tile_data : TileData = tile_map.get_cell_tile_data(layer, tile_mouse_pos)
	if tile_data:
		return tile_data.get_custom_data(custom_data_layer)
	else:
		return false
	

	
func handle_seed(tile_map_pos, level, atlas_coord, source_id, final_seed_level, a, b):
	tile_map.set_cell(environment_layer, tile_map_pos, source_id, atlas_coord)
	# create timer for the seed growth
	await get_tree().create_timer(5.0).timeout
	
	
	if level != final_seed_level:
		var new_atlas : Vector2i = Vector2i(atlas_coord.x +b, atlas_coord.y)
		tile_map.set_cell(environment_layer, tile_map_pos, source_id, new_atlas)
		handle_seed(tile_map_pos, level +a, new_atlas, source_id, final_seed_level, a , b)
		
	else:
		return
	
	
	
	
