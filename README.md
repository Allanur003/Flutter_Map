# 🗺️ Aşgabat Kartasy – Flutter App

Aşgabat şäheriniň interaktiw karta programmasy. Android üçin Flutter 3.24.5 bilen döredildi.

---

## 📦 Gurluş (Setup)

### Talap edilýän zatlar
- Flutter SDK **3.24.5** ýa-da täzesi
- Android Studio / VS Code
- Android SDK (min API 21)

### Gurnamak
```bash
cd ashgabat_map
flutter pub get
flutter run
```

---

## ✨ Funksiýalar

### 🗂️ Bölümler (Categories)
| Bölüm | Reňk | Sany |
|-------|------|------|
| 🚦 Swetaforlar | Narynç | 7 |
| 🚇 Tuneller | Ýaşyl | 5 |
| 🔄 Kruglar | Gyzyl | 6 |
| 🌉 Päddemkalar | Sary | 6 |
| 💧 Suw | Gök | 5 |

- Ählisini saýla / Hiçisini saýlama düwmesi
- Her bölüm aýratyn reňkde bellik bolup görünýär
- Bellige basamda maglumat kartoçkasy açylýar

### 🗺️ Karta görnüşleri
- **Adaty (Normal)** – CartoDB ýagty/garaňky çyzyk karta
- **Hemra (Satellite)** – ArcGIS dünýä hemra şekili
- Gije modunda karta hem garaňky bolýar

### 🌙 Gije / Gündiz Modi
- Gündiz: ýagty fon, ýagty karta
- Gije: garaňky fon, garaňky karta
- SharedPreferences bilen saklanyp galýar

### 🌐 Dil Saýlawy
- 🇹🇲 Türkmen
- 🇷🇺 Rusça
- 🇬🇧 Iňlisçe
- Ähli ýazgylary dil bilen üýtgeýär

### 🎛️ Dolandyryş
- Sol ýokarda: menýu düwmesi (animasiýaly açylýar)
- Sag aşakda: zoom+ / zoom- / merkeze gaýt
- Karta basamda menýu ýapylýar

---

## 📁 Faýl Gurluşy

```
lib/
├── main.dart                  ← Giriş nokady
├── models/
│   └── map_location.dart      ← Ähli ýerler we kategoriýalar
├── providers/
│   └── app_provider.dart      ← Ýagdaý dolandyryşy (Provider)
├── screens/
│   └── map_screen.dart        ← Esasy karta ekrany
├── widgets/
│   ├── side_menu.dart         ← Çep menýu
│   ├── map_marker_widget.dart ← Karta bellikleri
│   ├── location_info_card.dart← Ýer maglumat kartoçkasy
│   └── floating_controls.dart ← Ýüzleýin dolandyryjylar
└── l10n/
    └── app_localizations.dart ← 3 dil goldawy
```

---

## 📦 Paketler

```yaml
flutter_map: ^6.1.0         # Karta (flutter_map - OpenStreetMap)
latlong2: ^0.9.1             # Koordinat modeli
shared_preferences: ^2.3.2  # Sazlamalary saklamak
provider: ^6.1.2             # Ýagdaý dolandyryşy
flutter_localizations         # Dil goldawy
intl: ^0.19.0                # Internationalization
```

---

## 🗺️ Karta çeşmeleri

| Görnüş | URL |
|--------|-----|
| Gündiz çyzyk | `cartocdn.com/light_nolabels` |
| Gije çyzyk | `cartocdn.com/dark_nolabels` |
| Hemra | `arcgisonline.com/World_Imagery` |

---

## ➕ Täze ýer goşmak

`lib/models/map_location.dart` faýlynda `AshgabatData.locations` sanawyna goşuň:

```dart
MapLocation(
  id: 'rb_07',
  position: LatLng(37.9530, 58.3720),  // Koordinatlar
  category: LocationCategory.roundabout, // Kategoriýa
  names: {
    'tk': 'Täze kruk',
    'ru': 'Новый круг',
    'en': 'New Roundabout',
  },
),
```

---

## 🔧 Çözülmeli meseleler

**Internet ýok ýa-da karta açylmaýar:**
- `AndroidManifest.xml`-de `INTERNET` rugsady barmy?
- `flutter pub get` etdiňizmi?

**Dil üýtgänok:**
- `MaterialApp`-da `locale` we `localizationsDelegates` barmy? ✅ Bar

**Paket gabat gelmeýär:**
- Flutter `3.24.5` ýa-da täzesi ulanylýarmy?
- `flutter pub upgrade` ediň
