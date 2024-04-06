extends CharacterBody2D

const speed: int                = 100
var cur_dir: String             = 'none'
var enemy_inattack_range: bool  = false
var enemy_attack_cooldown: bool = true
@export var health: int                 = 200
var player_alive: bool          = true
var attack_ip: bool             = false


func _ready() -> void:
	$AnimatedSprite2D.play('front_idle')


func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	attack()
	
	if health <= 0:
		# go back to menu or respond
		player_alive = false
		health = 0
		print('player has bean killed')
		self.queue_free()


func player_movement(delta):
	if Input.is_action_pressed('ui_right'):
		cur_dir = 'right'
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed('ui_left'):
		cur_dir = 'left'
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed('ui_down'):
		cur_dir = 'down'
		play_anim(1)
		velocity.y = speed
		velocity.x = 0
	elif Input.is_action_pressed('ui_up'):
		cur_dir = 'up'
		play_anim(1)
		velocity.y = -speed
		velocity.x = 0
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0

	move_and_slide()


func play_anim(movement):
	var dir: String            = cur_dir
	var anim: AnimatedSprite2D = $AnimatedSprite2D

	if dir == 'right':
		anim.flip_h = false
		if movement == 1:
			anim.play('side_walk')
		elif movement == 0:
			if attack_ip == false:
				anim.play('side_idle')

	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play('side_walk')
		elif movement == 0:
			if attack_ip == false:
				anim.play('side_idle')

	if dir == "down":
		anim.flip_h = true
		if movement == 1:
			anim.play('front_walk')
		elif movement == 0:
			if attack_ip == false:
				anim.play('front_idle')

	if dir == "up":
		anim.flip_h = true
		if movement == 1:
			anim.play('back_walk')
		elif movement == 0:
			if attack_ip == false:
				anim.play('back_idle')


func player():
	pass


func _on_player_hitbox_body_entered(body):
	if body.has_method('enemy'):
		enemy_inattack_range =true


func _on_player_hitbox_body_exited(body):
	if body.has_method('enemy'):
		enemy_inattack_range  = false


func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true:
		health -= 20
		enemy_attack_cooldown = false
		$attach_colddown.start()
		print(health)


func _on_attach_colddown_timeout():
	enemy_attack_cooldown = true


func attack():
	var dir: String = cur_dir

	if Input.is_action_just_pressed('attack'):
		Global.player_current_attack = true
		attack_ip = true
		if dir == 'right':
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play('side_attack')
			$deal_attack_timer.start()
			
		if dir == 'left':
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play('side_attack')
			$deal_attack_timer.start()

		if dir == 'down':
			$AnimatedSprite2D.play('front_attack')
			$deal_attack_timer.start()

		if dir == 'up':
			$AnimatedSprite2D.play('back_attack')
			$deal_attack_timer.start()


func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	Global.player_current_attack = false
	attack_ip = false
