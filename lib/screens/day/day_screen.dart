import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'day_cubit.dart';

class DayScreen extends StatelessWidget  {
  final TextEditingController _timeController = TextEditingController();
  final DateTime date;

  DayScreen({
    Key? key,
    required this.date,
  }) : super(key: key);

  @override
    Widget build(BuildContext context) {
    return BlocBuilder<DayCubit, List>(
      builder: (BuildContext context, List items) {
        return Scaffold(
          appBar: AppBar(
            title: Text(date.toString()),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                      background: Container(
                        color: Colors.red,
                      ),
                      key: ValueKey<int>(items[index]),
                      onDismissed: (DismissDirection direction) {
                        context.read<DayCubit>().removeTask(index);
                      },
                      child: ListTile(
                        title: Text(
                          'Item ${items[index]}',
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: Form(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        TextFormField(
                         // onTap: () => _selectTime(context),
                          controller: _timeController,
                        ),
                        TextFormField(),
                        ElevatedButton(
                          onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Processing Data')),
                              );
                          },
                          child: const Text('Submit'),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
        );
      }
    );
  }

}
