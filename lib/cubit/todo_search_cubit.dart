import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class TodoSearchCubit extends Cubit<String> {
  final searchSubject = BehaviorSubject<String>();

  TodoSearchCubit() : super('') {
    //Input --> Debounce --> emit
    searchSubject.debounceTime(const Duration(microseconds: 300)).listen((
      query,
    ) {
      emit(query);
    });
  }

  void setQuery(String query) {
    searchSubject.add(query);
  }

  @override
  Future<void> close() {
    searchSubject.close();
    return super.close();
  }
}
