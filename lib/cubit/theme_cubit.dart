import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(ThemeMode.light));

  void toggleTheme() {
    emit(
      ThemeState(
        state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
      ),
    );
  }
}
