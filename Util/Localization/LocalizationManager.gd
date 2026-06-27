extends Node
# LocalizationManager.gd - Level 1 Localization System for BDCC
# Supports Russian (RU) and English (EN) languages
# Usage: TR("key") or LocalizationManager.translate("key")

class_name LocalizationManager

# Available languages
const LANGUAGE_ENGLISH = "EN"
const LANGUAGE_RUSSIAN = "RU"

var currentLanguage: String = LANGUAGE_ENGLISH
var translations: Dictionary = {}
var defaultLanguage: String = LANGUAGE_ENGLISH

func _ready():
	# Initialize localization on game start
	loadTranslations()
	applyLanguageSetting()

# Main translation function - use this everywhere!
func translate(key: String, language: String = "") -> String:
	if language.empty():
		language = currentLanguage
	
	# Try to find translation for current/specified language
	if translations.has(language) and translations[language].has(key):
		return translations[language][key]
	
	# Fallback to default language
	if language != defaultLanguage and translations.has(defaultLanguage) and translations[defaultLanguage].has(key):
		return translations[defaultLanguage][key]
	
	# Fallback to English if still not found
	if language != LANGUAGE_ENGLISH and translations.has(LANGUAGE_ENGLISH) and translations[LANGUAGE_ENGLISH].has(key):
		return translations[LANGUAGE_ENGLISH][key]
	
	# Last resort: return the key itself
	Log.printlog("[LocalizationManager] Missing translation for key: " + key)
	return key

# Get current language
func getLanguage() -> String:
	return currentLanguage

# Set language and update all UI elements
func setLanguage(language: String) -> bool:
	if language != LANGUAGE_ENGLISH and language != LANGUAGE_RUSSIAN:
		Log.printerr("[LocalizationManager] Invalid language: " + language)
		return false
	
	currentLanguage = language
	OPTIONS.setLocalization(language)  # Save to OPTIONS
	
	# Signal for UI elements to update
	get_tree().call_group("localization", "updateLocalization")
	
	return true

# Toggle between English and Russian
func toggleLanguage() -> String:
	if currentLanguage == LANGUAGE_ENGLISH:
		setLanguage(LANGUAGE_RUSSIAN)
	else:
		setLanguage(LANGUAGE_ENGLISH)
	return currentLanguage

# Load all translations from dictionary
func loadTranslations():
	translations = {
		LANGUAGE_ENGLISH: getEnglishTranslations(),
		LANGUAGE_RUSSIAN: getRussianTranslations()
	}

# Apply saved language setting from OPTIONS
func applyLanguageSetting():
	var savedLanguage = OPTIONS.getLocalization()
	if not savedLanguage.empty():
		setLanguage(savedLanguage)

# ============================================================================
# ENGLISH TRANSLATIONS (LEVEL 1 - UI STRINGS)
# ============================================================================
func getEnglishTranslations() -> Dictionary:
	return {
		# Main Menu Buttons
		"btn_resume": "Resume",
		"btn_new_game": "New game",
		"btn_load_game": "Load game",
		"btn_options": "Options",
		"btn_credits": "Credits",
		"btn_discord": "Join Discord",
		"btn_sex_toys": "Buttplug.IO",
		"btn_dev_tools": "DevTools",
		"btn_changelog": "Changelog",
		"btn_mods": "Mods",
		"btn_auto_translator": "AutoTranslator",
		"btn_datapacks": "Datapacks",
		"btn_troubleshooting": "Troubleshooting",
		"btn_quit": "Quit",
		
		# Main Menu Tooltips
		"tooltip_resume": "Load the latest save and continue playing",
		"tooltip_new_game": "Start a new game",
		"tooltip_load_game": "Load a previous game",
		"tooltip_options": "Open the settings menu",
		"tooltip_credits": "Check the credits",
		"tooltip_discord": "Join the game's discord server (18+ only)",
		"tooltip_sex_toys": "Open the sextoy integration menu",
		"tooltip_dev_tools": "Open the panel with the tools that are useful for content developers",
		"tooltip_changelog": "View the project's changelog",
		"tooltip_mods": "See what modules are loaded currently",
		"tooltip_auto_translator": "Experimental feature that translates scenes on the fly",
		"tooltip_datapacks": "Manage or create datapacks",
		"tooltip_troubleshooting": "Troubleshoot problems with the game",
		"tooltip_quit": "See you space cowboy...",
		
		# Dev Tools Buttons
		"btn_dev_close": "Close",
		"btn_scene_converter": "SceneConverter",
		"btn_npc_likes_gen": "Npc Likes Gen.",
		"btn_char_creator": "Char Creator",
		"btn_mod_maker": "ModMaker",
		"btn_old_scene_converter": "(old) SceneConverter",
		"btn_interaction_creator": "Interaction Creator",
		
		# Main Menu Strings
		"menu_title": "Broken Dreams Correctional Center",
		"menu_subtitle": "An erotic text-based rpg about being a prisoner in a space prison.",
		"menu_warning": "This game contains a lot of adult themes including sexual and fetish content and is meant to be played by adults only",
		"menu_created_by": "Created by Rahi",
		"menu_version": "Version: ",
		"menu_loaded_mods": "Loaded mods:",
		"menu_mod_single": "mod",
		"menu_mod_plural": "mods",
		
		# GitHub Release Messages
		"github_release_loading": "Latest github release: loading",
		"github_release_disabled": "Latest github release: DISABLED",
		"github_release_error": "Latest github release: Error",
		"github_release_nothing_found": "Latest github release: Nothing found",
		"github_release_label": "Latest github release: ",
		"github_release_your_version": "Your current version: ",
		"btn_github_releases": "Github Releases",
		
		# In-Game Menu (Pause Menu)
		"btn_save_game": "Save Game",
		"btn_load_game_ingame": "Load Game",
		"btn_main_menu": "Main Menu",
		"btn_sex_toy_manager": "Sex Toy Manager",
		"btn_datapacks_ingame": "Datapacks",
		
		# Save/Load Screen
		"save_slot_format": "Save",
		"load_slot_format": "Load",
		"save_file_name": "Save Name",
		"btn_import": "Import",
		"btn_export": "Export",
		"btn_delete": "Delete",
		"btn_save": "Save",
		"btn_close": "Close",
		"btn_prev_page": "<- Page",
		"btn_next_page": "Page ->",
		"tooltip_prev_page": "Flip to the previous page of options",
		"tooltip_next_page": "Flip to the next page of options",
		"tooltip_quick_save": "Save the game",
		"tooltip_quick_load": "Load the saved game",
		"btn_quick_save": "Quick save",
		"btn_quick_load": "Quick load",
		
		# Options Menu
		"options_title": "Options",
		"options_graphics": "Graphics",
		"options_sound": "Sound",
		"options_gameplay": "Gameplay",
		"options_language": "Language",
		"options_language_english": "English",
		"options_language_russian": "Русский",
		
		# Language Switcher (in-game)
		"language_en": "English",
		"language_ru": "Русский",
		
		# Error Messages
		"error_http_request": "An error occurred in the HTTP request.",
		"error_http_parse": "Couldn't parse json data from github.",
		"error_http_bad_data": "Bad data from github",
		"error_couldn_not_get_release": "Couldn't get the latest release from github",
		
		# Permissions
		"dialog_file_choose": "Choose File",
		
		# Datapack Menu
		"btn_datapack_new": "New Datapack",
		"btn_datapack_edit": "Edit",
		"btn_datapack_update": "Update",
		"datapack_author": "Author: ",
		"datapack_description": "Description",
		"datapack_contains": "Contains: ",
		"datapack_required_mods": "Required mods/datapacks: ",
		
		# Dialog Messages
		"dialog_alert": "Alert",
		"dialog_confirm": "Confirm",
		"dialog_cancel": "Cancel",
		"dialog_ok": "OK",
		"dialog_yes": "Yes",
		"dialog_no": "No",
	}

# ============================================================================
# RUSSIAN TRANSLATIONS (УРОВЕНЬ 1 - СТРОКИ ИНТЕРФЕЙСА)
# ============================================================================
func getRussianTranslations() -> Dictionary:
	return {
		# Кнопки главного меню
		"btn_resume": "Продолжить",
		"btn_new_game": "Новая игра",
		"btn_load_game": "Загрузить игру",
		"btn_options": "Параметры",
		"btn_credits": "Авторы",
		"btn_discord": "Discord",
		"btn_sex_toys": "Buttplug.IO",
		"btn_dev_tools": "Инструменты разработчика",
		"btn_changelog": "История изменений",
		"btn_mods": "Модули",
		"btn_auto_translator": "Автоперевод",
		"btn_datapacks": "Пакеты данных",
		"btn_troubleshooting": "Решение проблем",
		"btn_quit": "Выход",
		
		# Подсказки главного меню
		"tooltip_resume": "Загрузить последнее сохранение и продолжить игру",
		"tooltip_new_game": "Начать новую игру",
		"tooltip_load_game": "Загрузить предыдущую игру",
		"tooltip_options": "Открыть меню параметров",
		"tooltip_credits": "Просмотреть авторов",
		"tooltip_discord": "Присоединиться к Discord серверу игры (18+ только)",
		"tooltip_sex_toys": "Открыть меню интеграции секс-игрушек",
		"tooltip_dev_tools": "Открыть панель с инструментами для разработчиков контента",
		"tooltip_changelog": "Просмотреть историю изменений проекта",
		"tooltip_mods": "Посмотреть загруженные модули",
		"tooltip_auto_translator": "Экспериментальная функция автоматического перевода сцен",
		"tooltip_datapacks": "Управлять или создавать пакеты данных",
		"tooltip_troubleshooting": "Решить проблемы с игрой",
		"tooltip_quit": "До свидания, космический ковбой...",
		
		# Кнопки инструментов разработчика
		"btn_dev_close": "Закрыть",
		"btn_scene_converter": "Конвертер сцен",
		"btn_npc_likes_gen": "Генератор симпатий",
		"btn_char_creator": "Создатель персонажей",
		"btn_mod_maker": "Создатель модулей",
		"btn_old_scene_converter": "(старый) Конвертер сцен",
		"btn_interaction_creator": "Создатель взаимодействий",
		
		# Строки главного меню
		"menu_title": "Broken Dreams Correctional Center",
		"menu_subtitle": "Эротическая текстовая RPG о жизни заключённого в космической тюрьме.",
		"menu_warning": "Эта игра содержит множество взрослых тем, включая сексуальный и фетиш контент, и предназначена только для взрослых",
		"menu_created_by": "Создано Rahi",
		"menu_version": "Версия: ",
		"menu_loaded_mods": "Загруженные модули:",
		"menu_mod_single": "модуль",
		"menu_mod_plural": "модулей",
		
		# Сообщения о релизах GitHub
		"github_release_loading": "Последний релиз: загрузка",
		"github_release_disabled": "Последний релиз: ОТКЛЮЧЕНО",
		"github_release_error": "Последний релиз: Ошибка",
		"github_release_nothing_found": "Последний релиз: Не найден",
		"github_release_label": "Последний релиз: ",
		"github_release_your_version": "Ваша версия: ",
		"btn_github_releases": "Релизы на GitHub",
		
		# Меню паузы (в игре)
		"btn_save_game": "Сохранить игру",
		"btn_load_game_ingame": "Загрузить игру",
		"btn_main_menu": "Главное меню",
		"btn_sex_toy_manager": "Менеджер игрушек",
		"btn_datapacks_ingame": "Пакеты данных",
		
		# Экран сохранения/загрузки
		"save_slot_format": "Сохранение",
		"load_slot_format": "Загрузка",
		"save_file_name": "Имя сохранения",
		"btn_import": "Импортировать",
		"btn_export": "Экспортировать",
		"btn_delete": "Удалить",
		"btn_save": "Сохранить",
		"btn_close": "Закрыть",
		"btn_prev_page": "<- Предыдущая",
		"btn_next_page": "Следующая ->",
		"tooltip_prev_page": "Перейти на предыдущую страницу опций",
		"tooltip_next_page": "Перейти на следующую страницу опций",
		"tooltip_quick_save": "Сохранить игру",
		"tooltip_quick_load": "Загрузить сохранённую игру",
		"btn_quick_save": "Быстрое сохранение",
		"btn_quick_load": "Быстрая загрузка",
		
		# Меню параметров
		"options_title": "Параметры",
		"options_graphics": "Графика",
		"options_sound": "Звук",
		"options_gameplay": "Геймплей",
		"options_language": "Язык",
		"options_language_english": "English",
		"options_language_russian": "Русский",
		
		# Переключатель языка (в игре)
		"language_en": "English",
		"language_ru": "Русский",
		
		# Сообщения об ошибках
		"error_http_request": "При выполнении HTTP-запроса произошла ошибка.",
		"error_http_parse": "Не удалось обработать данные JSON с github.",
		"error_http_bad_data": "Неверные данные с github",
		"error_couldn_not_get_release": "Не удалось получить последний релиз с github",
		
		# Разрешения
		"dialog_file_choose": "Выберите файл",
		
		# Меню пакетов данных
		"btn_datapack_new": "Новый пакет",
		"btn_datapack_edit": "Редактировать",
		"btn_datapack_update": "Обновить",
		"datapack_author": "Автор: ",
		"datapack_description": "Описание",
		"datapack_contains": "Содержит: ",
		"datapack_required_mods": "Необходимые модули/пакеты: ",
		
		# Диалоговые окна
		"dialog_alert": "Предупреждение",
		"dialog_confirm": "Подтвердить",
		"dialog_cancel": "Отмена",
		"dialog_ok": "OK",
		"dialog_yes": "Да",
		"dialog_no": "Нет",
	}

# ============================================================================
# HELPER FUNCTION - Add to Util.gd or use as standalone
# ============================================================================
# Quick access function - add to global scope (in autoload/OPTIONS if preferred)
static func TR(key: String) -> String:
	if has_node("/root/LocalizationManager"):
		return get_node("/root/LocalizationManager").translate(key)
	# Fallback if not in tree
	return key
