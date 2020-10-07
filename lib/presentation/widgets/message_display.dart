import 'package:flutter/material.dart';

class MessageDisplay extends StatelessWidget {
  final String message;

  const MessageDisplay({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      child: SingleChildScrollView(
        child: Text(message, style: TextStyle(fontSize: 25), textAlign: TextAlign.center),
      ),
      constraints: BoxConstraints(minHeight: 50, maxHeight: MediaQuery.of(context).size.height / 3),
    );
  }
}
