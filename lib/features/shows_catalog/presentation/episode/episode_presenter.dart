import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/features/shows_catalog/domain/shows_catalog_entity.dart';
import 'package:showvis/features/shows_catalog/domain/shows_catalog_usecase.dart';
import 'package:showvis/features/shows_catalog/presentation/details/show_details_view_model.dart';
import 'package:intl/intl.dart';
import 'package:showvis/features/shows_catalog/presentation/episode/episode_view_model.dart';

class EpisodePresenter extends Presenter<ShowsCatalogUseCase,
    ShowsCatalogEntity, EpisodeViewModel> {
  EpisodePresenter(
      {super.key,
      required this.season,
      required this.number,
      required PresenterBuilder<EpisodeViewModel> builder})
      : super(builder: builder, provider: showsCatalogUseCase);

  final int season;
  final int number;

  @override
  EpisodeViewModel createViewModel(
      ShowsCatalogUseCase useCase, ShowsCatalogEntity entity) {
    // TODO It might be possible to fail to match an id with its data in the map,
    // so there should be a failure model to cover that edge case
    final episode = entity.episodes.map[season]![number]!;

    return EpisodeViewModel(
      name: episode.name,
      season: episode.season.toString(),
      number: episode.number.toString(),
      imageUrl: episode.imageUrl,
      summary: episode.summary,
      airDate:
          '${DateFormat.MMM().format(episode.airDate)} ${DateFormat.y().format(episode.airDate)} at ${DateFormat.Hm().format(episode.airDate)}',
    );
  }
}
