extends Label
# Компонент для переводимых лейблов
# Использование: Добавьте этот скрипт к Label и установите translation_key

export(String) var translation_key: String = ""
export(Dictionary) var translation_params: Dictionary = {}

func _ready():
	add_to_group("translatable")
	LocalizationManager.connect("language_changed", self, "update_translation")
	update_translation()

func update_translation():
	if translation_key.empty():
		return
	
	text = LocalizationManager.get_text(translation_key, translation_params)

func set_translation_key(key: String, params: Dictionary = {}):
	translation_key = key
	translation_params = params
	update_translation()
