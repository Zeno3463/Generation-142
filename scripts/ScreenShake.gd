extends Camera2D

var shake_amount = 0
var done = false

func _process(delta):
	if done: return
	offset = Vector2(
		rand_range(-shake_amount, shake_amount),
		rand_range(-shake_amount, shake_amount)
	) * delta
	
func shake(amplitude=100, time=0.4, amplitude_limit=100):
	done = false
	shake_amount += amplitude
	if shake_amount > amplitude_limit:
		shake_amount = amplitude_limit
	$Timer.wait_time = time
	$Timer.start()
	
func _on_Timer_timeout():
	shake_amount = 0
	offset = Vector2.ZERO
	done = true
	$Timer.stop()
