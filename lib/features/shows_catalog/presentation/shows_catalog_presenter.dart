import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/features/shows_catalog/domain/shows_catalog_entity.dart';
import 'package:showvis/features/shows_catalog/domain/shows_catalog_usecase.dart';
import 'package:showvis/features/shows_catalog/presentation/shows_catalog_view_model.dart';
import 'package:showvis/router.dart';

class ShowsCatalogPresenter extends Presenter<ShowsCatalogUseCase,
    ShowsCatalogEntity, ShowsCatalogViewModel> {
  ShowsCatalogPresenter(
      {super.key, required PresenterBuilder<ShowsCatalogViewModel> builder})
      : super(builder: builder, provider: showsCatalogUseCase);

  @override
  void onLayoutReady(context, useCase) {
    useCase.fetch();
  }

  @override
  ShowsCatalogViewModel createViewModel(
      ShowsCatalogUseCase useCase, ShowsCatalogEntity entity) {
    if (entity.state == EntityState.initial) {
      return const ShowsCatalogViewModel();
    }
    if (entity.state == EntityState.loading) {
      return const ShowsCatalogLoadingViewModel();
    } else if (entity.state == EntityState.networkError) {
      return ShowsCatalogNetworkFailureViewModel(retry: useCase.fetch);
    }
    return ShowsCatalogSuccessViewModel(
        shows: entity.shows.values.toList(),
        openDetails: (id) {
          router.push('/details/$id');
        });
  }
}
