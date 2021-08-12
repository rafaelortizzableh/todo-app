import 'package:flutter/material.dart';

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
