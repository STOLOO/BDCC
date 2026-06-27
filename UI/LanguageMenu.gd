extends Control
# Меню для переключения языка

onready var language_container = $"%LanguageContainer"
onready var title_label = $"%TitleLabel"

var language_buttons: Dictionary = {}

func _ready():
	setup_ui()
	LocalizationManager.connect("language_changed", self, "_on_language_changed")

# Создать кнопки для каждого языка
func setup_ui():
	if title_label:
		title_label.text = LocalizationManager.get_text("ui.language_menu.title")
	
	create_language_buttons()

# Создать и расставить кнопки языков
func create_language_buttons():
	if not language_container:
		return
	
	# Очистить старые кнопки
	for button in language_container.get_children():
		button.queue_free()
	
	language_buttons.clear()
	
	var languages = LocalizationManager.get_available_languages()
	var current_lang = LocalizationManager.get_current_language()
	
	for lang in languages:
		var button = Button.new()
		var display_name = LocalizationManager.get_language_display_name(lang)
		button.text = display_name
		button.name = lang
		button.modulate = Color(0.7, 0.7, 0.7)
		
		# Выделить активный язык
		if lang == current_lang:
			button.modulate = Color(0.3, 1, 0.3)  # Зеленый
			button.disabled = true
		
		language_container.add_child(button)
		language_buttons[lang] = button
		button.connect("pressed", self, "_on_language_button_pressed", [lang])

# Обработать нажатие на кнопку языка
func _on_language_button_pressed(language: String):
	if language != LocalizationManager.get_current_language():
		LocalizationManager.set_language(language)

# Обновить UI при изменении языка
func _on_language_changed(_new_language: String):
	create_language_buttons()
	if title_label:
		title_label.text = LocalizationManager.get_text("ui.language_menu.title")
	get_tree().call_group("translatable", "update_translation")
