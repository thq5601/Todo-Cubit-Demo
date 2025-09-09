import 'package:bloc_cubit/screen/todo_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

import '../cubit/theme_cubit.dart';
import '../cubit/language_cubit.dart';

class HomeScreen extends StatelessWidget {
  final String username;
  const HomeScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("welcome".tr(args: [username])),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              final languageCubit = context.read<LanguageCubit>();
              languageCubit.toggleLanguage();
              context.setLocale(languageCubit.state.locale);
            },
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "logout".tr(),
            onPressed: () {
              // Quay lại màn hình login
              context.goNamed('login');
            },
          ),
        ],
      ),
      body: const TodoScreen(),
    );
  }
}
