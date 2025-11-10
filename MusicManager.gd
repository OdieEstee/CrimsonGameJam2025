extends Node
var player: AudioStreamPlayer


# --- Map scenes to songs (use Right-click scene → Copy Path to avoid typos) ---
# Replace these example keys/values with your actual paths.
@export var scene_to_track: Dictionary = {
	"res://main_menu.tscn":        "res://Main_menu.mp3",         # example
	"res://level_1_scene.tscn":    "res://Main_menu.mp3",
	"res://level_2_scene.tscn":    "res://The_Final_of_Fantasy.mp3",
	"res://level_3_scene.tscn":    "res://Journey_Begins.mp3",
	"res://level_4_scene.tscn":    "res://CaveMusic.mp3",
	
	# you can add level 5 now; it won't error if it doesn't exist yet:
	"res://level_5_scene.tscn":    "res://Castle.mp3"
}

# Optional default if a scene isn't in the map:
@export var fallback_track_path: String = "res://arcade_music_one.mp3"

func _ready() -> void:
	# --- create the persistent player ---
	player = AudioStreamPlayer.new()
	add_child(player)
	player.bus = "Music"  # make sure you created a "Music" bus; else use "Master"
	process_mode = Node.PROCESS_MODE_ALWAYS
	


	# --- start once for the current scene (wait 1 frame so current_scene is set) ---
	await get_tree().process_frame
	_apply_for_current_scene()

	# --- react to later scene changes (Godot 4) ---
	var st := get_tree()
	if not st.scene_changed.is_connected(_on_scene_changed):
		st.scene_changed.connect(_on_scene_changed)

func _on_scene_changed(new_scene: Node) -> void:
	_apply_for_current_scene()

func _apply_for_current_scene() -> void:
	var cs := get_tree().current_scene
	if cs == null:
		return
		

	var scene_path := cs.scene_file_path
	var track_path := ""

	# Exact full-path match first
	if scene_path in scene_to_track:
		track_path = scene_to_track[scene_path]
	else:
		# Graceful fallback: allow keys that are just file names (e.g., "level_1_scene.tscn")
		var file_only := scene_path.get_file()
		for key in scene_to_track.keys():
			if key == file_only:
				track_path = scene_to_track[key]
				break

	if track_path == "" and fallback_track_path != "":
		track_path = fallback_track_path

	if track_path != "":
		play_track_once(track_path, 0.5)  # crossfade 0.5s
	else:
		push_warning("MusicManager: No track mapped for: %s" % scene_path)

func play_track_once(stream_path: String, crossfade_sec: float = 0.0) -> void:
	# Avoid crashes/halts if path is wrong or file missing
	if not ResourceLoader.exists(stream_path):
		push_warning("MusicManager: Track not found: %s" % stream_path)
		return

	var new_stream: AudioStream = load(stream_path)
	if new_stream is AudioStreamMP3 or new_stream is AudioStreamOggVorbis:
		new_stream.loop = true  # ensure looping

	# Same track already playing? Don't restart (keeps playback position)
	if player.stream == new_stream and player.playing:
		return

	if crossfade_sec > 0.0 and player.playing:
		await fade_to(-30.0, crossfade_sec)

	player.stream = new_stream
	player.play()

	if crossfade_sec > 0.0:
		await fade_to(0.0, crossfade_sec)

func fade_to(db_target: float, duration: float = 0.6) -> void:
	var steps := 20
	var start := player.volume_db
	for i in range(steps):
		var t := float(i + 1) / steps
		player.volume_db = lerp(start, db_target, t)
		await get_tree().create_timer(duration / steps).timeout

func fade_out_stop(duration: float = 0.6) -> void:
	var start := player.volume_db
	await fade_to(-40.0, duration)
	player.stop()
	player.volume_db = start
