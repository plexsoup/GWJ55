extends Node


var current_map
var current_player

var low_spec : bool = false

var user_settings = {
	"graphics":"high",
}

var player_stats = {
	"health_max":9,
	"health":9,
}

func reset_player():
	player_stats["health"] = player_stats["health_max"]
