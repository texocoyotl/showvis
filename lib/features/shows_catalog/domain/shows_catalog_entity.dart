import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/core/models.dart';
import 'package:showvis/core/stateful_collections.dart';

class ShowsCatalogEntity extends Entity {
  ShowsCatalogEntity({
    StatefulMap<int, Show>? showsInView,
    this.fromSearch = false,
    StatefulMap<int, Map<int, Episode>>? episodes,
    this.favoriteShows = const {},
    this.showsFromPeopleSearch = const {},
  })  : showsInView = showsInView ?? StatefulMap<int, Show>(),
        episodes = episodes ?? StatefulMap<int, Map<int, Episode>>();

  final StatefulMap<int, Show> showsInView;
  final bool fromSearch;
  final StatefulMap<int, Map<int, Episode>> episodes;
  final Map<int, Show> favoriteShows;
  final Map<int, Show> showsFromPeopleSearch;

  ShowsCatalogEntity merge({
    Map<int, Show>? shows,
    bool? fromSearch,
    StatefulMap<int, Show>? showsInView,
    StatefulMap<int, Map<int, Episode>>? episodes,
    Map<int, Show>? favoriteShows,
    Map<int, Show>? showsFromPeopleSearch,
  }) =>
      ShowsCatalogEntity(
        showsInView: showsInView ?? this.showsInView,
        fromSearch: fromSearch ?? this.fromSearch,
        episodes: episodes ?? this.episodes,
        favoriteShows: favoriteShows ?? this.favoriteShows,
        showsFromPeopleSearch:
            showsFromPeopleSearch ?? this.showsFromPeopleSearch,
      );

  @override
  List<Object?> get props =>
      [showsInView, fromSearch, episodes, favoriteShows, showsFromPeopleSearch];
}
