import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedStrings = {
    'tk': {
      'appTitle': 'Aşgabat Kartasy',
      'menu': 'Menýu',
      'categories': 'Bölümler',
      'trafficLights': 'Swetaforlar',
      'tunnels': 'Tuneller',
      'roundabouts': 'Kruglar',
      'underpasses': 'Päddemkalar',
      'selectAll': 'Ählisini saýla',
      'deselectAll': 'Hiçisini saýlama',
      'mapMode': 'Karta görnüşi',
      'satellite': 'Hemra',
      'normal': 'Adaty',
      'language': 'Dil',
      'turkmen': 'Türkmen',
      'russian': 'Rus',
      'english': 'Iňlis',
      'darkMode': 'Gije / Gündiz',
      'close': 'Ýap',
      'noMarkersSelected': 'Görkezmek üçin bir bölüm saýlaň',
      'locations': 'ýer',
      'settings': 'Sazlamalar',
      'night': 'Gije',
      'day': 'Gündiz',
    },
    'ru': {
      'appTitle': 'Карта Ашхабада',
      'menu': 'Меню',
      'categories': 'Категории',
      'trafficLights': 'Светофоры',
      'tunnels': 'Туннели',
      'roundabouts': 'Круги',
      'underpasses': 'Подземные переходы',
      'selectAll': 'Выбрать все',
      'deselectAll': 'Снять выбор',
      'mapMode': 'Режим карты',
      'satellite': 'Спутник',
      'normal': 'Обычный',
      'language': 'Язык',
      'turkmen': 'Туркменский',
      'russian': 'Русский',
      'english': 'Английский',
      'darkMode': 'Ночь / День',
      'close': 'Закрыть',
      'noMarkersSelected': 'Выберите категорию для отображения',
      'locations': 'мест',
      'settings': 'Настройки',
      'night': 'Ночь',
      'day': 'День',
    },
    'en': {
      'appTitle': 'Ashgabat Map',
      'menu': 'Menu',
      'categories': 'Categories',
      'trafficLights': 'Traffic Lights',
      'tunnels': 'Tunnels',
      'roundabouts': 'Roundabouts',
      'underpasses': 'Underpasses',
      'selectAll': 'Select All',
      'deselectAll': 'Deselect All',
      'mapMode': 'Map Mode',
      'satellite': 'Satellite',
      'normal': 'Normal',
      'language': 'Language',
      'turkmen': 'Turkmen',
      'russian': 'Russian',
      'english': 'English',
      'darkMode': 'Night / Day',
      'close': 'Close',
      'noMarkersSelected': 'Select a category to display',
      'locations': 'locations',
      'settings': 'Settings',
      'night': 'Night',
      'day': 'Day',
    },
  };

  String translate(String key) {
    final langCode = locale.languageCode;
    return _localizedStrings[langCode]?[key] ??
        _localizedStrings['tk']?[key] ??
        key;
  }

  String get appTitle => translate('appTitle');
  String get menu => translate('menu');
  String get categories => translate('categories');
  String get trafficLights => translate('trafficLights');
  String get tunnels => translate('tunnels');
  String get roundabouts => translate('roundabouts');
  String get underpasses => translate('underpasses');
  String get selectAll => translate('selectAll');
  String get deselectAll => translate('deselectAll');
  String get mapMode => translate('mapMode');
  String get satellite => translate('satellite');
  String get normal => translate('normal');
  String get language => translate('language');
  String get turkmen => translate('turkmen');
  String get russian => translate('russian');
  String get english => translate('english');
  String get darkMode => translate('darkMode');
  String get close => translate('close');
  String get noMarkersSelected => translate('noMarkersSelected');
  String get locations => translate('locations');
  String get settings => translate('settings');
  String get night => translate('night');
  String get day => translate('day');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['tk', 'ru', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
