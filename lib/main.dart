import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'providers/app_provider.dart';
import 'screens/map_screen.dart';
import 'l10n/app_localizations.dart';
import 'models/map_location.dart';
import 'services/overpass_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AshgabatData.load();
  
  if (AshgabatData.locations.isEmpty) {
    final overpassData = await OverpassService.fetchAll();
    if (overpassData.isNotEmpty) {
      AshgabatData.locations = overpassData;
      await AshgabatData.save();
    }
  }
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: const AshgabatMapApp(),
    ),
  );
}

class AshgabatMapApp extends StatelessWidget {
  const AshgabatMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(   
      builder: (context, provider, _) {
        return MaterialApp(
          title: 'Aşgabat Map',
          debugShowCheckedModeBanner: false,
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          locale: Locale(provider.languageCode),
          supportedLocales: const [
            Locale('tk'),
            Locale('ru'),
            Locale('en'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const MapScreen(),
        );
      },
    );
  }
}

class AppThemes {
  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A5F7A),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      );

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A5F7A),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      );
}
