extends Node

# Allows for movement in isometric tilemap
# param cartesian is the direction Vector2
func cartesian_to_isometric(cartesian):
	return Vector2(cartesian.x - cartesian.y, ((cartesian.x + cartesian.y) / 2))
