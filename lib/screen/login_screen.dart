import 'package:bloc_cubit/cubit/language_cubit.dart';
import 'package:bloc_cubit/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("login".tr()),
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
        ],
      ),
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            context.goNamed('home', extra: state.username);
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message.tr())));
          }
        },
        builder: (context, state) {
          if (state is LoginLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: "username".tr()),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: "password".tr()),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<LoginBloc>().add(
                      LoginSubmitted(
                        _usernameController.text,
                        _passwordController.text,
                      ),
                    );
                  },
                  child: Text("login".tr()),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
