import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit([Locale? initialLocale])
    : super(LanguageState(initialLocale ?? const Locale('vi')));

  void toggleLanguage() {
    final newLocale = state.locale.languageCode == 'vi'
        ? const Locale('en')
        : const Locale('vi');
    emit(LanguageState(newLocale));
  }
}
