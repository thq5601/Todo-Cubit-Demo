import 'package:bloc_cubit/cubit/todo_state.dart';
import 'package:bloc_cubit/models/todo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(TodoState(todos: []));

  final _uuid = const Uuid();

  //Tao phuong thuc CRUD
  //Phuong thuc add
  void addTodo(String title) {
    final newTodo = Todo(id: _uuid.v4(), title: title);
    emit(state.copyWith(todos: [...state.todos, newTodo]));
  }

  //Phuong thuc toggle
  void toggleTodo(String id) {
    final updatedTodos = state.todos.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(isComplete: !todo.isComplete);
      }
      return todo;
    }).toList();
    emit(state.copyWith(todos: updatedTodos));
  }

  //Phuong thuc update
  void updateTodo(String id, String newTitle) {
    final updatedTodos = state.todos.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(title: newTitle);
      }
      return todo;
    }).toList();
    emit(state.copyWith(todos: updatedTodos));
  }

  //Phuong thuc delete
  void deleteTodo(String id) {
    final updatedTodos = state.todos.where((todo) => todo.id != id).toList();
    emit(state.copyWith(todos: updatedTodos));
  }
}
