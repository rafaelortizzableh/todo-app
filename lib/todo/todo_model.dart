abstract class TodoList {
  List<String> todos = [];
  List<String> doneItems = [];

  TodoList(this.todos, this.doneItems);
}

class TodoListFromPrefs extends TodoList {
  TodoListFromPrefs(List<String> todos, List<String> doneItems)
      : super(todos, doneItems);
}

enum TypeOfTodos { done, todo }
