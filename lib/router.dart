import 'package:go_router/go_router.dart';
import 'package:showvis/features/show_details/presentation/show_details_ui.dart';
import 'package:showvis/features/shows_catalog/presentation/shows_catalog_ui.dart';

final GoRouter router = GoRouter(initialLocation: '/', routes: <GoRoute>[
  GoRoute(
    path: '/',
    builder: (context, state) => ShowsCatalogUI(),
  ),
  GoRoute(
    path: '/details/:id',
    builder: (context, state) {
      final id = int.parse(state.params['id'] ?? '-1');
      return ShowDetails(id);
    },
  ),
]);
