import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../global/global.dart';

import 'todo.dart';

final todoControllerProvider = StateNotifierProvider<TodoController, TodoList>(
    (ref) => TodoController(ref.watch(sharedPreferencesServiceProvider)));
