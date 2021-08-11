import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'todo.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
      ),
      body: TodoWidget(),
      floatingActionButton: AddTodoFAB(),
    );
  }
}

class TodoWidget extends ConsumerWidget {
  const TodoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Consumer(
            builder: (context, watch, child) {
              final List<String> todos = watch(todoControllerProvider).todos;
              return todos.length > 0
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Todo',
                            style: Theme.of(context).textTheme.headline2,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          height: (todos.length * 70) +
                              (todos.length < 2 ? 16 : 32),
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Card(
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              separatorBuilder: (context, index) => Divider(),
                              itemCount: todos.length,
                              itemBuilder: (context, index) => Dismissible(
                                key: UniqueKey(),
                                onDismissed: (horizontal) {
                                  watch(todoControllerProvider.notifier)
                                      .deleteTodoFromList(todo: todos[index]);
                                },
                                child: ListTile(
                                  title: Text(
                                    todos[index],
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      watch(todoControllerProvider.notifier)
                                          .deleteTodoFromList(
                                              todo: todos[index]);
                                    },
                                    icon: Icon(Icons.check_circle),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : FallbackWidget();
            },
          ),
          Consumer(
            builder: (context, watch, _) {
              final List<String> doneItems =
                  watch(todoControllerProvider).doneItems;

              return Container(
                child: doneItems.length > 0
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              'Done',
                              style: Theme.of(context).textTheme.headline2,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            height: (doneItems.length * 75) +
                                (doneItems.length < 2 ? 16 : 32),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Card(
                              child: ListView.separated(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                separatorBuilder: (context, index) => Divider(),
                                itemCount: doneItems.length,
                                itemBuilder: (context, index) => Dismissible(
                                  key: UniqueKey(),
                                  onDismissed: (horizontal) =>
                                      watch(todoControllerProvider.notifier)
                                          .deleteTodoFromDoneItems(
                                              todo: doneItems[index]),
                                  child: ListTile(
                                    title: Text(
                                      doneItems[index],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                              color: Colors.grey.shade400,
                                              decoration:
                                                  TextDecoration.lineThrough),
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
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
              );
            },
          )
        ],
      ),
    );
  }
}

class FallbackWidget extends StatelessWidget {
  const FallbackWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '🦾\nCheers\nYou have no pending todos.\nPress the Floating Button to add a new one',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );
  }
}

class AddTodoFAB extends StatelessWidget {
  const AddTodoFAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        return FloatingActionButton(
            onPressed: () async {
              String? todo = await showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return BottomSheetTextInput();
                  });
              if (todo != null && todo.length > 0 && todo.trim().length > 0) {
                watch(todoControllerProvider.notifier)
                    .addTodoToList(todo: todo);
              }
            },
            child: Icon(CupertinoIcons.pen));
      },
    );
  }
}

class BottomSheetTextInput extends StatefulWidget {
  const BottomSheetTextInput({
    Key? key,
  }) : super(key: key);

  @override
  _BottomSheetTextInputState createState() => _BottomSheetTextInputState();
}

class _BottomSheetTextInputState extends State<BottomSheetTextInput> {
  final TextEditingController _controller = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'New Todo',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64),
            child: TextField(
              autofocus: true,
              autocorrect: true,
              controller: _controller,
              onSubmitted: (text) => Navigator.pop(context, text),
              decoration: InputDecoration(hintText: 'Type your todo here...'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64),
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context, _controller.text),
              icon: Icon(Icons.add),
              label: Text('Add todo'),
            ),
          ),
        ],
      ),
    );
  }
}
