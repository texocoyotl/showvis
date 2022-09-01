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
  ShowDetailsViewModel createViewModel(
      ShowsCatalogUseCase useCase, ShowsCatalogEntity entity) {
    // TODO It might be possible to fail to match an id with its data in the catalog,
    // so there should be a failure model to cover that edge case

    final show = entity.shows[id]!;
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
      timeSchedule: DateFormat.Hm().format(show.timeSchedule),
      daysSchedule: show.daysSchedule.join(', '),
      summary: show.summary,
      rating: show.rating.toString(),
    );
  }
}
