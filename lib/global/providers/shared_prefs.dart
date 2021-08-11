import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../global.dart';

// Instance of Shared Preferences Service (will be overriden on startup)
final sharedPreferencesServiceProvider =
    Provider<SharedPrefsService>((ref) => throw UnimplementedError());
