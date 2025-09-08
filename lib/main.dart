import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'bloc/login_bloc.dart';
import 'cubit/theme_cubit.dart';
import 'cubit/language_cubit.dart';
import 'cubit/theme_state.dart';
import 'routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('vi')],
      path: 'assets/translations',
      fallbackLocale: const Locale('vi'),
      startLocale: const Locale('vi'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginBloc()),
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => LanguageCubit(context.locale)),
      ],
      child: Builder(
        // 👈 Builder để context lấy được BlocProviders ở trên
        builder: (context) {
          return BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              return MaterialApp.router(
                title: 'Bloc & Cubit Demo',
                debugShowCheckedModeBanner: false,
                themeMode: themeState.themeMode,
                theme: ThemeData.light(),
                darkTheme: ThemeData.dark(),
                // easy_localization
                locale: context.locale.languageCode.isEmpty
                    ? const Locale('vi')
                    : context.locale,
                supportedLocales: context.supportedLocales,
                localizationsDelegates: context.localizationDelegates,
                // go_router
                routerConfig: AppRouter.router,
              );
            },
          );
        },
      ),
    );
  }
}
