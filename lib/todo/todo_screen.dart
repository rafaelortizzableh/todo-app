import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';
import 'todo.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Builder(builder: (context) {
        final TabController tabController = DefaultTabController.of(context)!;
        return Scaffold(
          appBar: AppBar(
            title: Text('Todo App'),
            bottom: TabBar(
              tabs: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Todo ⏳'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Done 👍'),
                ),
              ],
              controller: tabController,
            ),
          ),
          body: TabBarView(
            children: [TodosWidget(), DoneItemsWidget()],
            controller: tabController,
          ),
          floatingActionButton: AddTodoFAB(),
        );
      }),
    );
  }
}

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

enum TypeOfTodos { done, todo }

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

class FallbackWidget extends StatelessWidget {
  const FallbackWidget({Key? key, required this.typeOfTodo}) : super(key: key);
  final TypeOfTodos typeOfTodo;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RiveAnimationWidget(typeOfTodo: typeOfTodo),
          Text(
            typeOfTodo == TypeOfTodos.todo
                ? 'You have no pending todos.\nPress the Floating Button to add a new one'
                : 'You have no done items.\nEat an 🍎 or 🧠 or something... ',
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
                  isScrollControlled: true,
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
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets,
      duration: const Duration(milliseconds: 100),
      curve: Curves.decelerate,
      child: Container(
        alignment: Alignment.bottomCenter,
        height: MediaQuery.of(context).size.height * 0.25,
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
                textCapitalization: TextCapitalization.sentences,
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
      ),
    );
  }
}

class RiveAnimationWidget extends StatefulWidget {
  const RiveAnimationWidget({Key? key, required this.typeOfTodo})
      : super(key: key);
  final TypeOfTodos typeOfTodo;
  @override
  _RiveAnimationWidgetState createState() => _RiveAnimationWidgetState();
}

class _RiveAnimationWidgetState extends State<RiveAnimationWidget> {
  late RiveAnimationController _controller;
  @override
  void initState() {
    _controller = OneShotAnimation('Idle', autoplay: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      child: RiveAnimation.asset(
        widget.typeOfTodo == TypeOfTodos.todo
            ? 'assets/animations/new_file.riv'
            : 'assets/animations/zombie_character.riv',
        animations: widget.typeOfTodo == TypeOfTodos.todo
            ? const ['Idle']
            : const ['Walk'],
      ),
    );
  }
}
