import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/core/models.dart';
import 'package:showvis/core/stateful_collections.dart';
import 'package:showvis/dependencies/favorites_persistance.dart';
import 'package:showvis/dependencies/http_client.dart';
import 'package:showvis/features/shows_catalog/domain/shows_catalog_entity.dart';
import 'package:showvis/main.dart';

class ShowsCatalogUseCase extends UseCase<ShowsCatalogEntity> {
  ShowsCatalogUseCase() : super(entity: ShowsCatalogEntity()) {
    _loadFavoriteShows();
  }

  static int showsPerView = 250; //TODO Change to a shared preferences value
  static int showsPerAPICall = 250;

  int _currentPageOfShowsInView = 0;
  final Map<int, Show> _shows = {};

  void fetchShowsInView() async {
    if (entity.showsInView.map.isNotEmpty) {
      _currentPageOfShowsInView++;
    }

    final map = (entity.fromSearch) ? <int, Show>{} : entity.showsInView.map;
    entity = entity.merge(
        fromSearch: false,
        showsInView:
            StatefulMap<int, Show>(map: map, state: CollectionState.loading));

    final initialShowID = _currentPageOfShowsInView * showsPerView + 1;
    final lastShowID = _currentPageOfShowsInView * showsPerView + showsPerView;

    final showsFound = await _fetchShowsCatalogIfNeeded(initialShowID);
    if (!showsFound) {
      entity = entity.merge(
          fromSearch: false,
          showsInView: StatefulMap<int, Show>(
              map: const {}, state: CollectionState.networkError));
      return;
    }

    final Map<int, Show> showsPerPage = Map.from(_shows)
      ..removeWhere((k, v) => k > lastShowID);

    entity = entity.merge(
        fromSearch: false,
        showsInView: StatefulMap<int, Show>(
            map: Map.from(entity.showsInView.map)..addAll(showsPerPage),
            state: CollectionState.populated));

    print(entity.showsInView.map.length);
  }

  Future<bool> _fetchShowsCatalogIfNeeded(int initialShowID) async {
    if (_shows.containsKey(initialShowID)) return true;

    final page = (initialShowID / showsPerAPICall).floor();

    print('Query for Shows on Page $page');

    final JsonResponse res =
        await getIt<HttpClient>().query(path: 'shows?page=$page');

    if (res is JsonFailureResponse) return false;

    final List<dynamic> list = (res as JsonSuccessResponse).content;

    _shows.addAll({for (var show in list) show['id']: Show.fromJson(show)});
    return true;
  }

  Future<void> search(String text) async {
    if (text.trim().isEmpty) return;

    entity = entity.merge(
        fromSearch: true,
        showsInView: StatefulMap<int, Show>(
            map: const {}, state: CollectionState.loading));

    print('Search for Shows with $text');

    final JsonResponse res =
        await getIt<HttpClient>().query(path: 'search/shows?q=$text');

    if (res is JsonFailureResponse) {
      entity = entity.merge(
          fromSearch: true,
          showsInView: StatefulMap<int, Show>(
              map: const {}, state: CollectionState.networkError));
      return;
    }

    final List<dynamic> list = (res as JsonSuccessResponse).content;

    entity = entity.merge(
        showsInView: StatefulMap<int, Show>(map: {
      for (var show in list) show['show']['id']: Show.fromJson(show['show'])
    }, state: CollectionState.populated));
  }

  void clearEpisodes() {
    entity = entity.merge(
        episodes: StatefulMap<int, Map<int, Episode>>(
            map: const {}, state: CollectionState.loading));
  }

  void fetchEpisodes(int id) async {
    // If the list is already fetched, this will avoid doing the query again
    // when the user is just tapping the tabs back and forth
    if (entity.episodes.state == CollectionState.populated) return;

    entity = entity.merge(
        episodes: StatefulMap<int, Map<int, Episode>>(
            map: const {}, state: CollectionState.loading));

    final JsonResponse res =
        await getIt<HttpClient>().query(path: 'shows/$id/episodes');

    if (res is JsonFailureResponse) {
      entity = entity.merge(
          episodes: StatefulMap<int, Map<int, Episode>>(
              map: const {}, state: CollectionState.networkError));
      return;
    }

    final episodes = <int, Map<int, Episode>>{};

    for (var episodeData in (res as JsonSuccessResponse).content) {
      final episode = Episode.fromJson(episodeData);

      if (!episodes.containsKey(episode.season)) episodes[episode.season] = {};
      episodes[episode.season]![episode.number] = episode;
    }

    entity = entity.merge(
        episodes: StatefulMap<int, Map<int, Episode>>(
      map: episodes,
      state: CollectionState.populated,
    ));
  }

  Future<void> toggleFavorite(int showId) async {
    if (entity.favoriteShows.containsKey(showId)) {
      entity = entity.merge(
          favoriteShows: Map.from(entity.favoriteShows)..remove(showId));
    } else {
      entity = entity.merge(
          favoriteShows: Map.from(entity.favoriteShows)
            ..addAll({showId: _shows[showId]!}));
    }
    getIt<FavoritesPersistance>().persistFavoriteShows(entity.favoriteShows);
  }

  Future<void> _loadFavoriteShows() async {
    final favoriteShows =
        await getIt<FavoritesPersistance>().retrieveFavoriteShows();
    entity = entity.merge(favoriteShows: favoriteShows);
  }
}

final showsCatalogUseCase =
    UseCaseProvider<ShowsCatalogEntity, ShowsCatalogUseCase>(
  (_) => ShowsCatalogUseCase(),
);

enum ShowsNavigation { backwards, current, forward }
