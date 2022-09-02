import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/core/stateful_collections.dart';
import 'package:showvis/dependencies/http_client/http_client.dart';
import 'package:showvis/features/shows_catalog/domain/shows_catalog_entity.dart';
import 'package:showvis/main.dart';

class ShowsCatalogUseCase extends UseCase<ShowsCatalogEntity> {
  ShowsCatalogUseCase() : super(entity: ShowsCatalogEntity());

  void fetch() async {
    // this will create a new view model, followed by an UI update
    entity = entity.merge(state: EntityState.loading);

    final JsonResponse res =
        await getIt<HttpClient>().query(path: 'shows?page=0');

    if (res is JsonFailureResponse) {
      entity = entity.merge(state: EntityState.networkError);
      return;
    }

    // With successful data received, the state obtains the response, producing
    // the normal view model / UI update
    final List<dynamic> list = (res as JsonSuccessResponse).content;
    entity = entity.merge(
      state: EntityState.completed,
      shows: {for (var show in list) show['id']: Show.fromJson(show)},
    );
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
