import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:todo/src/tasks/screens/task_detail_screen.dart';
import 'package:todo/src/tasks/screens/tasks_list_screen.dart';

import 'settings/settings_controller.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          scaffoldMessengerKey: rootScaffoldMessengerKey,
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
            ),
            textTheme: TextTheme(
              displayLarge: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
              ),
              titleLarge: GoogleFonts.josefinSans(
                fontSize: 28,
              ),
              bodyMedium: GoogleFonts.inter(),
              displaySmall: GoogleFonts.sourceSans3(),
            ),
            appBarTheme: AppBarTheme(
              // For some reason the app bar is not defaulting to having a background color.
              backgroundColor: Colors.blue[900],
              foregroundColor: Colors.white,
            ),
          ),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,

          debugShowCheckedModeBanner: false,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          // onGenerateRoute: (RouteSettings routeSettings) {
          //   return MaterialPageRoute<void>(
          //     settings: routeSettings,
          //     builder: (BuildContext context) {
          //       switch (routeSettings.name) {
          //         case SettingsView.routeName:
          //           return SettingsView(controller: settingsController);
          //         case SampleItemDetailsView.routeName:
          //           return const SampleItemDetailsView();
          //         case SampleItemListView.routeName:
          //         default:
          //           return const SampleItemListView();
          //       }
          //     },
          //   );
          // },

          // vs Routes....
          routes: {
            '/': (ctx) => TasksListScreen(),
            TaskDetailScreen.routeName: (ctx) => TaskDetailScreen(),
          },
        );
      },
    );
  }
}
