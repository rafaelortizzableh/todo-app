import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../todo.dart';

class DoneItemsWidget extends StatelessWidget {
  const DoneItemsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Consumer(
        builder: (context, watch, child) {
          List<String> doneItems = watch(todoControllerProvider).doneItems;
          return doneItems.length > 0
              ? ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: doneItems.length,
                  itemBuilder: (context, index) => Dismissible(
                    key: UniqueKey(),
                    onDismissed: (horizontal) =>
                        watch(todoControllerProvider.notifier)
                            .deleteTodoFromDoneItems(todo: doneItems[index]),
                    child: SizedBox(
                      child: ListTile(
                        title: Text(
                          doneItems[index],
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  color: Colors.grey.shade400,
                                  decoration: TextDecoration.lineThrough),
                        ),
                        trailing: IconButton(
                          onPressed: () =>
                              watch(todoControllerProvider.notifier)
                                  .deleteTodoFromDoneItems(
                                      todo: doneItems[index]),
                          icon: Icon(Icons.remove_circle),
                        ),
                      ),
                    ),
                  ),
                )
              : FallbackWidget(
                  typeOfTodo: TypeOfTodos.done,
                );
        },
      ),
    );
  }
}
