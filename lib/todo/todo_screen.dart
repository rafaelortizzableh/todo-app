import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
