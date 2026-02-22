import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/incidents/presentation/pages/incidents_list_page.dart';
import '../features/incidents/presentation/pages/incident_details_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const IncidentsListPage(),
      ),
      GoRoute(
        path: '/incident/:id',
        builder: (context, state) =>
            IncidentDetailsPage(incidentId: state.pathParameters['id']!),
      ),
    ],
  );
});