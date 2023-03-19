extends Node


var current_map
var current_player
var current_hud
var kitty = false
var low_spec : bool = false

var user_settings = {
	"graphics":"high",
}

var player_stats = {
	"health_max":9,
	"health":9,
}

var abilities_unlocked = [
	"spawn_box",
	"double_jump",
	"dash",
]

var doors_open = [] # important doors will add themselves to this list, based on door_id parameter.


func reset_player():
	player_stats["health"] = player_stats["health_max"]
