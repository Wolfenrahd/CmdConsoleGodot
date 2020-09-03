extends CanvasLayer

onready var label = $PanelContainer/VBox/ScrollContainer/Label;
onready var line_edit = $PanelContainer/VBox/LineEdit;

func _ready() -> void:
	pass

func _on_LineEdit_text_entered(new_text: String) -> void:
	if new_text != "":
		label.text += new_text + "\n";
		line_edit.text = "";
		
		var i = new_text.find(" ");
		var func_name := "";
		
		if i == -1:
			func_name = new_text;
		else:
			func_name = new_text.substr(0, i);
		
		var arguments := [];
		while(i != -1):
			var next_i = new_text.find(" ", i + 1);
			
			if next_i == -1:
				arguments.append(new_text.substr(i + 1));
			else:
				var length = next_i - i;
				arguments.append(new_text.substr(i + 1, length));
			
			i = next_i;
		
		if has_method(func_name):
			if not call(func_name, arguments):
				label.text += "Not enough arguments!\n";


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("command"):
		$PanelContainer.visible = !$PanelContainer.visible;

func help(arguments) -> bool:
	if arguments.size() == 0:
		label.text += "load_map name\n";
	return true;

func print_apple(arguments) -> bool:
	if arguments.size() == 0:
		return false;
	else:
		label.text += "apple " + arguments[0] + '\n';
		return true;

func load_level(arguments) -> bool:
	if arguments.size() == 0:
		return false;
	else:
		if LevelLoader.level_name != "":
			get_node("/root/" + LevelLoader.level_name).queue_free();
		
		print("res://levels/" + arguments[0] + ".tscn");
		var level = load("res://levels/" + arguments[0] + ".tscn").instance();
		get_node("/root").add_child(level);
		
		return true;

func toilet(argument) -> bool:
	print("FLUSH");
	label.text += "FLUSH\n";
	return true;
