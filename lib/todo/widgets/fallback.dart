import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import '../todo.dart';

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
