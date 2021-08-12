import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../todo.dart';

class TodosWidget extends StatelessWidget {
  const TodosWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Consumer(
        builder: (context, watch, child) {
          List<String> todos = watch(todoControllerProvider).todos;
          return todos.length > 0
              ? ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: todos.length,
                  itemBuilder: (context, index) => Dismissible(
                    key: UniqueKey(),
                    onDismissed: (horizontal) {
                      watch(todoControllerProvider.notifier)
                          .deleteTodoFromList(todo: todos[index]);
                    },
                    child: SizedBox(
                      child: ListTile(
                        title: Text(
                          todos[index],
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            watch(todoControllerProvider.notifier)
                                .deleteTodoFromList(todo: todos[index]);
                          },
                          icon: Icon(Icons.check_circle),
                        ),
                      ),
                    ),
                  ),
                )
              : FallbackWidget(typeOfTodo: TypeOfTodos.todo);
        },
      ),
    );
  }
}
