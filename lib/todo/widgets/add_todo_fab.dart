import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../todo.dart';

class AddTodoFAB extends StatelessWidget {
  const AddTodoFAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        return FloatingActionButton(
          onPressed: () async {
            String? todo = await showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return BottomSheetTextInput();
                });
            if (todo != null && todo.length > 0 && todo.trim().length > 0) {
              watch(todoControllerProvider.notifier).addTodoToList(todo: todo);
            }
          },
          child: Icon(CupertinoIcons.pen),
        );
      },
    );
  }
}
