extends Label

func _process(delta):
	var secs = GameManager.get_run_time()
	text = "Time: %s" % GameManager.get_run_time_string()
