import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/presentation/bloc/number_trivia/number_trivia_bloc.dart';

class TriviaControls extends StatefulWidget {
  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  String inputStr;
  final controller = TextEditingController();
  Timer _timer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Input a number"),
          onChanged: (value) {
            inputStr = value;
            dispatchOnTyping();
          },
          onSubmitted: (_) {
            dispatchConcrete(false);
          },
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: RaisedButton(
                child: Text("Search"),
                textColor: Colors.white,
                color: Theme.of(context).accentColor,
                textTheme: ButtonTextTheme.primary,
                onPressed: () => dispatchConcrete(false),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: RaisedButton(
                child: Text("Get random trivia"),
                color: Theme.of(context).secondaryHeaderColor,
                textTheme: ButtonTextTheme.primary,
                onPressed: dispatchRandom,
              ),
            )
          ],
        )
      ],
    );
  }

  void dispatchConcrete(bool isTyping) {
    if (!isTyping) controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForConcreteNumber(inputStr));
  }

  void dispatchRandom() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }

  void dispatchOnTyping() {
    if (_timer != null) _timer.cancel();
    _timer = Timer(Duration(milliseconds: 500), () {
      if (inputStr.length > 0) {
        dispatchConcrete(true);
      }
    });
  }
}
