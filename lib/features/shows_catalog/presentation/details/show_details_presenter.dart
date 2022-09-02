import 'package:showvis/core/architecture_components.dart';
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
    final show = entity.showsInView.list[id];

    return ShowDetailsViewModel(
      name: show.name,
      largeImageUri: show.largeImageUri,
      genres: show.genres.join(' | '),
      premiered: show.ended.isAfter(DateTime.now())
          ? 'Unknown'
          : '${DateFormat.MMM().format(show.premiered)} ${DateFormat.y().format(show.premiered)}',
      ended: show.ended.isAfter(DateTime.now())
          ? 'Currently airing'
          : '${DateFormat.MMM().format(show.ended)} ${DateFormat.y().format(show.ended)}',
      timeSchedule: show.timeSchedule,
      daysSchedule: show.daysSchedule.join(', '),
      summary: show.summary,
      rating: show.rating.toString(),
      episodes: entity.episodes,
      onTabChange: (index) {
        if (index == 1) useCase.fetchEpisodes(id);
      },
    );
  }
}
