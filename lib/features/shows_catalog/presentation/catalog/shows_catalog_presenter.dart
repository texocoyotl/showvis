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
  ShowsCatalogViewModel createViewModel(
      ShowsCatalogUseCase useCase, ShowsCatalogEntity entity) {
    return ShowsCatalogViewModel(
      shows: entity.showsInView.map.values.toList(),
      fromSearch: entity.fromSearch,
      isLoading: entity.showsInView.state == CollectionState.loading,
      hasError: entity.showsInView.state == CollectionState.networkError,
      refresh: useCase.fetchShowsInView,
      openDetails: (id) {
        router.push('/details/$id');
      },
      search: useCase.search,
      goToNextPage: useCase.fetchShowsInView,
      retry:
          entity.fromSearch ? useCase.search : (_) => useCase.fetchShowsInView,
    );
  }
}
