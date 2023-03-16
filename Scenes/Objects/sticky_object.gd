"""
Sticky surfaces are intended to give the player wall hang capabilities.
Maybe wall climb if they have that ability.
Maybe even velcro power for grabbing tossed objects.

"""

extends Node3D

signal touched


func _on_area_3d_body_entered(body):
	if "player" in body.name.to_lower():
		if body.has_method("_on_sticky_surface_touched"):
			if not touched.is_connected(body._on_sticky_surface_touched):
				touched.connect(body._on_sticky_surface_touched)
			touched.emit()
