extends Node

# Система локализации для BDCC
# Использование: LocalizationManager.get_text("key_name")

var current_language: String = "en"
var translations: Dictionary = {}
var available_languages: Array = ["en", "ru"]

const TRANSLATIONS_PATH: String = "res://Localization/translations/"
const CONFIG_PATH: String = "user://localization_settings.cfg"

signal language_changed(new_language)

func _ready():
	load_language_setting()
	load_all_translations()

# Загрузить все переводы для доступных языков
func load_all_translations():
	translations.clear()
	
	for lang in available_languages:
		var file_path = TRANSLATIONS_PATH + lang + ".json"
		var file = File.new()
		
		if file.file_exists(file_path):
			file.open(file_path, File.READ)
			var json = JSON.parse(file.get_as_text())
			file.close()
			
			if json.error == OK:
				translations[lang] = json.result
			else:
				push_error("Error loading translations for language: " + lang)
		else:
			push_error("Translation file not found: " + file_path)

# Получить переведенный текст
func get_text(key: String, params: Dictionary = {}) -> String:
	if not translations.has(current_language):
		return key
	
	var lang_dict = translations[current_language]
	var text = _get_nested_value(lang_dict, key)
	
	if text == null:
		push_warning("Translation key not found: " + key + " for language: " + current_language)
		return key
	
	# Заменить параметры в текст
	for param_key in params:
		text = text.replace("{" + param_key + "}", str(params[param_key]))
	
	return text

# Получить вложенное значение из словаря (поддержка точечной нотации)
func _get_nested_value(dict: Dictionary, key: String):
	var keys = key.split(".")
	var current = dict
	
	for k in keys:
		if current is Dictionary and current.has(k):
			current = current[k]
		else:
			return null
	
	return current

# Установить текущий язык
func set_language(language: String):
	if language not in available_languages:
		push_error("Language not available: " + language)
		return
	
	current_language = language
	save_language_setting()
	emit_signal("language_changed", language)

# Получить текущий язык
func get_current_language() -> String:
	return current_language

# Получить список доступных языков
func get_available_languages() -> Array:
	return available_languages

# Сохранить выбранный язык в конфиг
func save_language_setting():
	var config = ConfigFile.new()
	config.set_value("localization", "language", current_language)
	config.save(CONFIG_PATH)

# Загрузить выбранный язык из конфига
func load_language_setting():
	var config = ConfigFile.new()
	
	if config.load(CONFIG_PATH) == OK:
		if config.has_section_key("localization", "language"):
			current_language = config.get_value("localization", "language")
			if current_language not in available_languages:
				current_language = "en"
	else:
		current_language = "en"

# Получить название языка на русском
func get_language_display_name(language: String) -> String:
	var names = {
		"en": "English",
		"ru": "Русский"
	}
	return names.get(language, language.to_upper())
