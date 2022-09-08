import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/core/models.dart';
import 'package:showvis/features/shows_catalog/domain/shows_catalog_entity.dart';
import 'package:showvis/features/shows_catalog/domain/shows_catalog_usecase.dart';
import 'package:showvis/features/shows_catalog/presentation/details/show_details_view_model.dart';
import 'package:intl/intl.dart';

class ShowDetailsPresenter extends Presenter<ShowsCatalogUseCase,
    ShowsCatalogEntity, ShowDetailsViewModel> {
  ShowDetailsPresenter(
      {super.key,
      required this.id,
      required PresenterBuilder<ShowDetailsViewModel> builder})
      : super(builder: builder, provider: showsCatalogUseCase);

  final int id;

  @override
  void onLayoutReady(context, useCase) {
    useCase.clearEpisodes();
  }

  @override
  ShowDetailsViewModel createViewModel(
      ShowsCatalogUseCase useCase, ShowsCatalogEntity entity) {
    Show show = entity.showsInView.map[id] ??
        entity.favoriteShows[id] ??
        entity.showsHistory[id]!;

    return ShowDetailsViewModel(
      name: show.name,
      largeImageUri: show.largeImageUri,
      genres: show.genres.join(' | '),
      premiered:
          '${DateFormat.MMM().format(show.premiered)} ${DateFormat.y().format(show.premiered)}',
      ended: show.ended == DateTime.parse('2999-01-01')
          ? 'Not ended yet'
          : '${DateFormat.MMM().format(show.ended)} ${DateFormat.y().format(show.ended)}',
      timeSchedule: show.timeSchedule,
      daysSchedule: show.daysSchedule.join(', '),
      summary: show.summary,
      rating: show.rating.toString(),
      episodes: entity.episodes,
      onTabChange: (index) {
        if (index == 1) useCase.fetchEpisodes(id);
      },
      isFavorite: entity.favoriteShows.containsKey(id),
      toggleFavorite: () => useCase.toggleFavorite(show.id),
    );
  }
}
