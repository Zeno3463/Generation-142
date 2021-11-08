extends Camera2D

export var amplitude = 500
export var frequency = 0.5
export var time = 0.3

var done = true
onready var shake_amplitude = amplitude
onready var shake_frequency = frequency
onready var shake_time = time

# handle screen shake
func _process(_delta):
	if not done:
		shake()
	else:
		$Timer.stop()
		$Tween.stop_all()
		reset()
	
# start the screen shake
func start(_amplitude=amplitude, _frequency=frequency, _time=time):
	return
	if done:
		done = false
		shake_amplitude = _amplitude
		shake_frequency = _frequency
		$Timer.wait_time = shake_time
		$Timer.start()
	
# the shake mechanism
func shake():
	return
	var rand = Vector2.ZERO
	rand.x = rand_range(-shake_amplitude, shake_amplitude)
	rand.y = rand_range(-shake_amplitude, shake_amplitude)
	
	$Tween.interpolate_property(self, 
	"offset", 
	self.offset, 
	rand, 
	shake_frequency, 
	Tween.TRANS_SINE, 
	Tween.EASE_IN_OUT)
	$Tween.start()

# the reset mechanism
func reset():
	return
	$Tween.interpolate_property(self, 
	"offset", 
	self.offset, 
	Vector2(), 
	shake_frequency, 
	Tween.TRANS_SINE, 
	Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	$Tween.stop_all()

func _on_Timer_timeout():
	return
	done = true

