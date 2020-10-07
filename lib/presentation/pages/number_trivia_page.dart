import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/presentation/bloc/number_trivia/number_trivia_bloc.dart';
import 'package:number_trivia/presentation/widgets/widgets.dart';

import '../../injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) => BlocProvider(
        create: (context) => sl<NumberTriviaBloc>(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TriviaControls(),
              SizedBox(height: 10),
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return MessageDisplay(message: "");
                  }
                  if (state is Error) {
                    return MessageDisplay(message: state.message);
                  }
                  if (state is Loading) {
                    return LoadingWidget();
                  }
                  if (state is Loaded) {
                    return TriviaDisplay(trivia: state.trivia);
                  }
                  return Container();
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      );
}
