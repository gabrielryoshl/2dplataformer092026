extends CanvasLayer


@onready var version_label: Label = %VersionLabel


func _ready() -> void:
	version_label.text = ProjectSettings.get_setting("application/config/version", "0.0.0-development")
