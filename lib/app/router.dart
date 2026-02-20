import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/incidents/presentation/pages/incidents_list_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/incidents',
    routes: [
      GoRoute(
        path: '/incidents',
        builder: (context, state) => const IncidentsListPage(),
      ),
    ],
  );
});