import 'package:go_router/go_router.dart';
import 'package:showvis/features/shows_catalog/presentation/catalog/shows_catalog_ui.dart';
import 'package:showvis/features/shows_catalog/presentation/details/show_details_ui.dart';
import 'package:showvis/features/shows_catalog/presentation/episode/episode_ui.dart';

final GoRouter router = GoRouter(initialLocation: '/', routes: <GoRoute>[
  GoRoute(
    path: '/',
    builder: (context, state) => ShowsCatalogUI(),
  ),
  GoRoute(
    path: '/details/:id',
    builder: (context, state) {
      final id = int.parse(state.params['id'] ?? '-1');
      return ShowDetailsUI(id: id);
    },
  ),
  GoRoute(
    path: '/episode/:season/:number',
    builder: (context, state) {
      final season = int.parse(state.params['season'] ?? '-1');
      final number = int.parse(state.params['number'] ?? '-1');
      return EpisodeUI(
        season: season,
        number: number,
      );
    },
  ),
]);
