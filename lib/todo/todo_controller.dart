import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../global/global.dart';

import 'todo.dart';

class TodoController extends StateNotifier<TodoList> {
  TodoController(this.prefs)
      : super(TodoListFromPrefs(prefs.getTodosFromStorage ?? [],
            prefs.getDoneItemsFromStorage ?? []));
  final SharedPrefsService prefs;

  void addTodoToList({required String todo}) async {
    List<String> todos = [...state.todos, todo];
    bool todoAdded = await prefs.updateTodoList(todos);
    state = todoAdded
        ? TodoListFromPrefs(prefs.getTodosFromStorage ?? [],
            prefs.getDoneItemsFromStorage ?? [])
        : state;
  }

  void deleteTodoFromList({required todo}) async {
    List<String> todos = state.todos;
    bool removed = todos.remove(todo);
    bool todoMarkedAsDone = await prefs
        .updateDoneItemsList([...prefs.getDoneItemsFromStorage ?? [], todo]);
    bool todoRemoved = await prefs.updateTodoList(todos);
    state = (removed && todoRemoved && todoMarkedAsDone)
        ? TodoListFromPrefs(prefs.getTodosFromStorage ?? [],
            prefs.getDoneItemsFromStorage ?? [])
        : state;
  }

  void deleteTodoFromDoneItems({required todo}) async {
    List<String> todos = state.doneItems;
    bool removed = todos.remove(todo);
    bool todoRemoved = await prefs.updateDoneItemsList(todos);
    state = (removed && todoRemoved)
        ? TodoListFromPrefs(prefs.getTodosFromStorage ?? [],
            prefs.getDoneItemsFromStorage ?? [])
        : state;
  }
}
