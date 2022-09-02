import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/core/stateful_collections.dart';
import 'package:showvis/features/shows_catalog/domain/shows_catalog_entity.dart';
import 'package:showvis/features/shows_catalog/domain/shows_catalog_usecase.dart';
import 'package:showvis/features/shows_catalog/presentation/catalog/shows_catalog_view_model.dart';
import 'package:showvis/router.dart';

class ShowsCatalogPresenter extends Presenter<ShowsCatalogUseCase,
    ShowsCatalogEntity, ShowsCatalogViewModel> {
  ShowsCatalogPresenter(
      {super.key, required PresenterBuilder<ShowsCatalogViewModel> builder})
      : super(builder: builder, provider: showsCatalogUseCase);

  @override
  void onLayoutReady(context, useCase) {
    useCase.fetchShowsInViewNextPage();
  }

  @override
  ShowsCatalogViewModel createViewModel(
      ShowsCatalogUseCase useCase, ShowsCatalogEntity entity) {
    if (entity.showsInView.state == CollectionState.initial) {
      return const ShowsCatalogViewModel();
    } else if (entity.showsInView.state == CollectionState.loading) {
      return const ShowsCatalogLoadingViewModel();
    } else if (entity.showsInView.state == CollectionState.networkError) {
      return ShowsCatalogNetworkFailureViewModel(
          retry: useCase.fetchShowsInViewNextPage);
    }
    return ShowsCatalogSuccessViewModel(
        shows: entity.showsInView.list,
        openDetails: (id) {
          router.push('/details/$id');
        },
        goToNextPage: () => useCase.fetchShowsInViewNextPage(
            direction: ShowsNavigation.forward),
        goToPreviousPage: () => useCase.fetchShowsInViewNextPage(
            direction: ShowsNavigation.backwards));
  }
}
