import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'dettaglio_page.dart';
import 'diagnostica_page.dart';
import 'home_page.dart';
import 'nuovo_promemoria_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      ),
    GoRoute(
      path: '/nuovo',
      builder: (context, state) => const NuovoPromemoriaPage(),
      ),
    GoRoute(
      path: '/promemoria/:id',
      builder: (context, state) => DettaglioPage(
        id: int.parse(state.pathParameters['id']!),
        ),
      ),
    GoRoute(
      path: '/diagnostica',
      builder: (context, state) => const DiagnosticaPage(),
      ),
  ]
  );

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Promemoria',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      routerConfig: appRouter,
      locale: const Locale('it'),
      supportedLocales: const [Locale('it'), Locale('en')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
    );
  }
}