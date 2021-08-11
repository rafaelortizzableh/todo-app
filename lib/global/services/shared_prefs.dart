import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  final SharedPreferences prefs;
  SharedPrefsService({
    required this.prefs,
  });

  List<String>? get getTodosFromStorage => prefs.getStringList('todos');
  List<String>? get getDoneItemsFromStorage => prefs.getStringList('doneItems');

  Future<bool> updateTodoList(List<String> todos) async {
    bool result = await prefs.setStringList('todos', todos);
    return result;
  }

  Future<bool> updateDoneItemsList(List<String> doneItems) async {
    bool result = await prefs.setStringList('doneItems', doneItems);
    return result;
  }
}
