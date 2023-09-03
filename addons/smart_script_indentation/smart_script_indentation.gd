@tool
extends EditorPlugin


### Objects ###

var editor_interface: EditorInterface
var script_editor: ScriptEditor
var script_code: CodeEdit
var delay_timer: Timer


### Settings ###

var enter_count: int
var delay: int = 1


func _init() -> void:
	delay_timer = Timer.new() as Timer
	delay_timer.wait_time = delay
	delay_timer.one_shot = true
	add_child(delay_timer)


func _enter_tree() -> void:
	delay_timer.timeout.connect(_on_delay_timer_timeout)


func _exit_tree() -> void:
	script_editor.editor_script_changed.disconnect(_on_editor_script_changed)
	script_code.text_changed.disconnect(_on_text_changed)
	delay_timer.timeout.disconnect(_on_delay_timer_timeout)


func _process(delta: float) -> void:
	editor_interface = get_editor_interface()
	script_editor = editor_interface.get_script_editor()
	script_editor.editor_script_changed.connect(_on_editor_script_changed)
	script_code = script_editor.get_current_editor().get_base_editor() as CodeEdit
	script_code.text_changed.connect(_on_text_changed)
	set_process(false)
	

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_pressed() and event.keycode == KEY_ENTER and Input.is_key_pressed(KEY_SHIFT):
			var caret_position: int = script_code.get_caret_line()
			for next_line in range(1, 4):
				var line = script_code.get_line(caret_position + next_line).begins_with("func")
				if line:
					if next_line == 1:
						script_code.insert_line_at(caret_position, "")
						script_code.insert_line_at(caret_position, "")
						script_code.insert_line_at(caret_position, "")
						script_code.insert_line_at(caret_position, "")
						script_code.set_caret_line(caret_position + 2)
					elif next_line == 2:
						script_code.insert_line_at(caret_position, "")
						script_code.insert_line_at(caret_position, "")
						script_code.insert_line_at(caret_position, "")
						script_code.set_caret_line(caret_position + 2)
					elif next_line == 3:
						script_code.insert_line_at(caret_position, "")
						script_code.insert_line_at(caret_position, "")
						script_code.set_caret_line(caret_position + 2)
			delay_timer.stop()
			enter_count = 0


func _on_editor_script_changed(_script: Script) -> void:
	script_code.text_changed.disconnect(_on_text_changed)
	script_code = script_editor.get_current_editor().get_base_editor() as CodeEdit
	script_code.text_changed.connect(_on_text_changed)
	delay_timer.stop()
	enter_count = 0


func _on_delay_timer_timeout() -> void:
	enter_count = 0


func _on_text_changed() -> void:
	if Input.is_key_pressed(KEY_ENTER):
		enter_count += 1
		if enter_count == 1:
			delay_timer.start()
		elif enter_count >= 3:
			var caret_position: int = script_code.get_caret_line()
			for next_line in range(1, 4):
				var line = script_code.get_line(caret_position + next_line).begins_with("func")
				if line:
					if next_line == 1:
						script_code.insert_line_at(caret_position, "")
						script_code.insert_line_at(caret_position, "")
						script_code.insert_line_at(caret_position, "")
						script_code.insert_line_at(caret_position, "")
						script_code.set_caret_line(caret_position + 2)
					elif next_line == 2:
						script_code.insert_line_at(caret_position, "")
						script_code.insert_line_at(caret_position, "")
						script_code.insert_line_at(caret_position, "")
						script_code.set_caret_line(caret_position + 2)
					elif next_line == 3:
						script_code.insert_line_at(caret_position, "")
						script_code.insert_line_at(caret_position, "")
						script_code.set_caret_line(caret_position + 2)
			delay_timer.stop()
			enter_count = 0
