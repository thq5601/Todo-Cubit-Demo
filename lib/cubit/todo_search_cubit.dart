import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class TodoSearchCubit extends Cubit<String> {
  final searchSubject = BehaviorSubject<String>();

  TodoSearchCubit() : super('') {
    //Input --> Debounce --> emit
    //Subscribe lắng nghe sự kiện từ searchSubject
    searchSubject.debounceTime(const Duration(microseconds: 300)).listen((
      query,
    ) {
      emit(query);
    });
  }

  //Phương thức set query, những input từ searchBox sẽ được add vào searchSubject
  void setQuery(String query) {
    searchSubject.add(query);
  }

  @override
  Future<void> close() {
    //Close để tránh memory leak
    searchSubject.close();
    return super.close();
  }
}
