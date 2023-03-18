extends Node


var current_map
var current_player
var current_hud

var low_spec : bool = true

var user_settings = {
	"graphics":"low",
}

var player_stats = {
	"health_max":9,
	"health":9,
}

var abilities_unlocked = [
	"spawn_box",
	"double_jump",
	"cloud_kitty",
	"dash",
]

func reset_player():
	player_stats["health"] = player_stats["health_max"]
