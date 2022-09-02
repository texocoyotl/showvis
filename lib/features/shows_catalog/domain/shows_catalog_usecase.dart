import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/core/stateful_collections.dart';
import 'package:showvis/dependencies/http_client/http_client.dart';
import 'package:showvis/features/shows_catalog/domain/shows_catalog_entity.dart';
import 'package:showvis/main.dart';

class ShowsCatalogUseCase extends UseCase<ShowsCatalogEntity> {
  ShowsCatalogUseCase() : super(entity: ShowsCatalogEntity());

  static int showsPerView = 25; //TODO Change to a shared preferences value
  static int showsPerAPICall = 250;

  int _currentPageOfShowsInView = 0;
  final Map<int, Show> _shows = {};

  void fetchShowsInViewNextPage({direction = ShowsNavigation.current}) async {
    if (direction == ShowsNavigation.forward) {
      _currentPageOfShowsInView++;
    } else if (direction == ShowsNavigation.backwards &&
        _currentPageOfShowsInView > 0) {
      _currentPageOfShowsInView--;
    } else if (direction == ShowsNavigation.backwards &&
        _currentPageOfShowsInView == 0) {
      return;
    }

    entity = entity.merge(
        showsInView:
            StatefulList<Show>(list: const [], state: CollectionState.loading));

    final initialShowID = _currentPageOfShowsInView * showsPerView + 1;
    final lastShowID = _currentPageOfShowsInView * showsPerView + showsPerView;

    final showsFound = await _fetchShowsCatalogIfNeeded(initialShowID);
    if (!showsFound) {
      entity = entity.merge(
          showsInView: StatefulList<Show>(
              list: const [], state: CollectionState.networkError));
      return;
    }

    final Map<int, Show> showsPerPage = Map.from(_shows)
      ..removeWhere((k, v) => k < initialShowID || k > lastShowID);

    entity = entity.merge(
        showsInView: StatefulList<Show>(
            list: showsPerPage.values.toList(),
            state: CollectionState.populated));
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
}

final showsCatalogUseCase =
    UseCaseProvider<ShowsCatalogEntity, ShowsCatalogUseCase>(
  (_) => ShowsCatalogUseCase(),
);

enum ShowsNavigation { backwards, current, forward }
