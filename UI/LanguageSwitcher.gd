extends Control
# UI компонент для переключения языка

onready var language_option = $"%LanguageOptionButton"
onready var confirm_dialog = $"%ConfirmationDialog"

var selected_language: String

func _ready():
	setup_language_options()
	if language_option:
		language_option.connect("item_selected", self, "_on_language_selected")

# Инициализировать меню выбора языка
func setup_language_options():
	if not language_option:
		return
	
	language_option.clear()
	
	var languages = LocalizationManager.get_available_languages()
	var current_lang = LocalizationManager.get_current_language()
	
	for i in range(languages.size()):
		var lang = languages[i]
		var display_name = LocalizationManager.get_language_display_name(lang)
		language_option.add_item(display_name, i)
		
		if lang == current_lang:
			language_option.select(i)

# Обработать выбор языка
func _on_language_selected(index: int):
	var languages = LocalizationManager.get_available_languages()
	selected_language = languages[index]
	
	if selected_language == LocalizationManager.get_current_language():
		return
	
	if confirm_dialog:
		var lang_name = LocalizationManager.get_language_display_name(selected_language)
		confirm_dialog.dialog_text = LocalizationManager.get_text("ui.dialogs.confirm_language_change", {"language": lang_name})
		confirm_dialog.popup_centered()
		var _ok = confirm_dialog.connect("confirmed", self, "_on_language_confirmed")
		var _cancel = confirm_dialog.connect("cancelled", self, "_on_language_cancelled")

func _on_language_confirmed():
	LocalizationManager.set_language(selected_language)
	refresh_ui()

func _on_language_cancelled():
	setup_language_options()

# Обновить текстовые элементы
func refresh_ui():
	get_tree().call_group("translatable", "update_translation")
