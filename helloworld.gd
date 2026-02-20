extends Node2D

var dragged_body: RigidBody2D = null

func _ready():
	# Get viewport size
	var viewport_size = get_viewport_rect().size

	# Create a floor centered horizontally near the bottom
	var floor_body = StaticBody2D.new()
	var floor_shape = CollisionShape2D.new()
	floor_shape.shape = RectangleShape2D.new()
	floor_shape.shape.extents = Vector2(400, 20)  # width, height
	floor_body.position = Vector2(viewport_size.x / 2.0, viewport_size.y - 100)
	floor_body.add_child(floor_shape)
	add_child(floor_body)

	# Text and spacing
	var text = "HELLO WORLD"
	var letter_spacing = 60   # spacing between letters

	# Calculate total width of all letters
	var total_width = text.length() * letter_spacing

	# Get viewport center
	var center_x = viewport_size.x / 2.0
	var start_x = center_x - total_width / 2.0

	# Generate letters
	var x = start_x
	for c in text:
		var letter = RigidBody2D.new()
		var shape = CollisionShape2D.new()
		shape.shape = RectangleShape2D.new()
		shape.shape.extents = Vector2(40, 40)      # bigger collider for bigger letters
		letter.add_child(shape)

		var label = Label.new()
		label.text = str(c)
		label.scale = Vector2(2, 2)                # make letters bigger
		label.position = Vector2(-20, -20)         # center text relative to collider
		letter.add_child(label)

		# Position letters horizontally centered
		letter.position = Vector2(x, 100)
		add_child(letter)
		x += letter_spacing

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var query = PhysicsPointQueryParameters2D.new()
			query.position = event.position
			query.collide_with_areas = false
			query.collide_with_bodies = true

			var space_state = get_world_2d().direct_space_state
			var result = space_state.intersect_point(query)

			if result.size() > 0 and result[0].collider is RigidBody2D:
				dragged_body = result[0].collider
				dragged_body.linear_velocity = Vector2.ZERO
				dragged_body.angular_velocity = 0
				dragged_body.gravity_scale = 0
		elif not event.pressed and event.button_index == MOUSE_BUTTON_LEFT and dragged_body:
			# Restore gravity
			dragged_body.gravity_scale = 1
			# Add bounce impulse when releasing
			dragged_body.apply_impulse(Vector2(randf_range(-100, 100), -200))
			dragged_body = null

	elif event is InputEventMouseMotion and dragged_body:
		dragged_body.global_position = event.position
