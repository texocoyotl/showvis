import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/features/shows_catalog/domain/shows_catalog_entity.dart';
import 'package:showvis/features/shows_catalog/domain/shows_catalog_usecase.dart';
import 'package:showvis/features/shows_catalog/presentation/shows_catalog_view_model.dart';

class ShowsCatalogPresenter extends Presenter<ShowsCatalogUseCase,
    ShowsCatalogEntity, ShowsCatalogViewModel> {
  ShowsCatalogPresenter(
      {super.key, required PresenterBuilder<ShowsCatalogViewModel> builder})
      : super(builder: builder, provider: showsCatalogUseCase);

  @override
  ShowsCatalogViewModel createViewModel(
      ShowsCatalogUseCase useCase, ShowsCatalogEntity entity) {
    return ShowsCatalogViewModel(
        fetchShows: useCase.fetch, shows: entity.shows);
  }
}
