import 'package:bloc/bloc.dart';

class DayCubit extends Cubit<List> {
  static final List<int> items = List<int>.generate(10, (int index) => index);

  // static final data = {
  //   date,
  //   items
  // };

  DayCubit() : super(items);

  void removeTask(id) {
    state.removeAt(id);
    emit(state);
  }

  void addTask(id) {
     
  }
}

// class DayStateModel {
//     Todo({
//     String? id,
//     required this.title,
//     this.description = '',
//     this.isCompleted = false,
//   })
// }