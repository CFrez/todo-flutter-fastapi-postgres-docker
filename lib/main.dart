import 'package:family/src/children/providers/child_details_provider.dart';
import 'package:family/src/parent/providers/parent_details_provider.dart';
import 'package:family/src/parent/providers/parents_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

GetIt getIt = GetIt.instance;

void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  WidgetsFlutterBinding.ensureInitialized();

  setupSingletons();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp(settingsController: settingsController));
}

void setupSingletons() {
  getIt.registerSingleton<ParentsListProvider>(
    ParentsListProviderImpl(),
    signalsReady: true,
  );
  getIt.registerSingleton<ParentDetailsProvider>(
    ParentDetailsProviderImpl(),
    signalsReady: true,
  );
  getIt.registerSingleton<ChildDetailsProvider>(
    ChildDetailsProviderImpl(),
    signalsReady: true,
  );
}
