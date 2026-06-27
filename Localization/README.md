# Система локализации BDCC

## Описание

Полная система многоязычной поддержки для игры Broken Dreams Correctional Center.

## Структура файлов

```
Localization/
├── LocalizationManager.gd          # Главный менеджер локализации
├── translations/
│   ├── en.json                    # Английские переводы
│   └── ru.json                    # Русские переводы
└── README.md                       # Этот файл

UI/
├── LanguageSwitcher.gd            # Компонент для переключения языка
├── LanguageMenu.gd                # Меню выбора языка
├── TranslatableLabel.gd           # Переводимый Label
└── TranslatableButton.gd          # Переводимая Button
```

## Установка

### 1. Добавить автозагрузку

Отройте `Project` → `Project Settings` → `Autoload`:
- Добавьте `Localization/LocalizationManager.gd` с именем `LocalizationManager`

### 2. Создать сцены меню

Добавьте `LanguageMenu.gd` в ваше главное меню для переключения языка.

## Использование

### Получить переведенный текст

```gdscript
label.text = LocalizationManager.get_text("ui.main_menu.title")
```

### С параметрами

```gdscript
var message = LocalizationManager.get_text("ui.dialogs.confirm_language_change", {"language": "Русский"})
```

### Изменить язык

```gdscript
LocalizationManager.set_language("ru")
```

### Получить текущий язык

```gdscript
var current = LocalizationManager.get_current_language()
```

### Использовать TranslatableLabel

1. Добавьте `TranslatableLabel.gd` к Label ноде
2. В Inspector установите `Translation Key` на нужный ключ (например: `ui.main_menu.title`)
3. Label автоматически обновится при смене языка

## Добавление новых переводов

### Добавить ключ перевода

1. Откройте `Localization/translations/en.json`
2. Добавьте новый ключ:

```json
{
  "ui": {
    "my_category": {
      "my_key": "My English text"
    }
  }
}
```

3. Добавьте тот же ключ в `ru.json`:

```json
{
  "ui": {
    "my_category": {
      "my_key": "Мой русский текст"
    }
  }
}
```

### Использов��ть в коде

```gdscript
LocalizedLabel.set_translation_key("ui.my_category.my_key")
```

## Добавление нового языка

1. Создайте новый JSON файл в `Localization/translations/` (например: `es.json` для испанского)
2. Скопируйте структуру из `en.json` и переведите все ключи
3. Отредактируйте `LocalizationManager.gd`:

```gdscript
var available_languages: Array = ["en", "ru", "es"]

func get_language_display_name(language: String) -> String:
    var names = {
        "en": "English",
        "ru": "Русский",
        "es": "Español"
    }
    return names.get(language, language.to_upper())
```

## Группы для локализации

Все узлы, которые должны обновляться при смене языка, добавляются в группу `"translatable"`:

```gdscript
add_to_group("translatable")
```

Они будут автоматически обновлены при вызове:

```gdscript
get_tree().call_group("translatable", "update_translation")
```

## Сохранение выбора языка

Выбранный язык автоматически сохраняется в `user://localization_settings.cfg` и будет загружен при следующем запуске игры.

## Сигналы

Менеджер отправляет сигнал при смене языка:

```gdscript
LocalizedManager.connect("language_changed", self, "on_language_changed")

func on_language_changed(new_language: String):
    print("Язык изменён на: " + new_language)
```

## Примечания

- Все переводы хранятся в JSON файлах для удобства редактирования
- Система использует точечную нотацию для вложенных ключей (например: `ui.main_menu.title`)
- Параметры в переводах заключаются в фигурные скобки: `{parameter_name}`
- Текущий язык сохраняется и восстанавливается при перезагрузке
