import 'package:app_bar_with_search_switch/app_bar_with_search_switch.dart';
import 'package:flutter/material.dart';
import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/features/shows_catalog/domain/shows_catalog_entity.dart';
import 'package:showvis/features/shows_catalog/presentation/catalog/shows_catalog_presenter.dart';
import 'package:showvis/features/shows_catalog/presentation/catalog/shows_catalog_view_model.dart';

class ShowsCatalogUI extends UI<ShowsCatalogViewModel> {
  ShowsCatalogUI({super.key});

  final isSearchMode = ValueNotifier<bool>(false);
  final searchText = ValueNotifier<String>('');

  @override
  Widget build(BuildContext context, ShowsCatalogViewModel viewModel) {
    return WillPopScope(
      onWillPop: () async {
        if (searchText.value != '') {
          isSearchMode.value = false;
          searchText.value = '';
          if (viewModel is ShowsCatalogSuccessViewModel) viewModel.refresh();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBarWithSearchSwitch(
          customIsSearchModeNotifier: isSearchMode,
          customTextNotifier: searchText,
          closeOnSubmit: false,
          clearOnSubmit: false,
          onSubmitted: (viewModel is ShowsCatalogSuccessViewModel)
              ? viewModel.search
              : null,
          onClosed: (viewModel is ShowsCatalogWithContentViewModel)
              ? viewModel.refresh
              : null,
          appBarBuilder: (context) {
            return AppBar(
              title: const Text('ShowVis'),
              actions: const [
                AppBarSearchButton(
                  buttonHasTwoStates: false,
                ),
              ],
            );
          },
        ),
        body: _body(context, viewModel),
      ),
    );
  }

  Widget _body(BuildContext context, ShowsCatalogViewModel viewModel) {
    if (viewModel is ShowsCatalogNetworkFailureViewModel) {
      return _errorBody(context, viewModel);
    }
    if (viewModel is ShowsCatalogLoadingViewModel) {
      return _loadingBody(context, viewModel);
    }
    if (viewModel is ShowsCatalogSuccessViewModel) {
      return _successBody(context, viewModel, viewModel.goToPreviousPage,
          viewModel.goToNextPage);
    }
    return Container();
  }

  Widget _errorBody(BuildContext context,
          ShowsCatalogNetworkFailureViewModel viewModel) =>
      Center(
        child: Column(
          children: [
            const Text(
                'The list cannot be retrieved at this moment, please check you have Internet connection.'),
            ElevatedButton(
                onPressed: () => viewModel.retry(searchText.value),
                child: const Text('Retry')),
          ],
        ),
      );

  Widget _loadingBody(
          BuildContext context, ShowsCatalogLoadingViewModel viewModel) =>
      const Center(child: CircularProgressIndicator());

  Widget _successBody(
          BuildContext context,
          ShowsCatalogSuccessViewModel viewModel,
          VoidCallback goToPreviousPage,
          VoidCallback goToNextPage) =>
      Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              ElevatedButton(
                  onPressed: goToPreviousPage, child: const Text('Back')),
              ElevatedButton(
                  onPressed: goToNextPage, child: const Text('Next')),
            ],
          ),
          Expanded(
            child: ListView(
              children: viewModel.shows
                  .map((show) => _showRow(show, viewModel.openDetails))
                  .toList(),
            ),
          ),
        ],
      );

  Widget _showRow(
    Show show,
    ValueChanged<int> openDetails,
  ) =>
      Card(
        child: ListTile(
          leading: Text(show.id.toString()),
          title: Text(show.name),
          onTap: () => openDetails(show.id),
        ),
      );

  @override
  Presenter create(PresenterBuilder<ShowsCatalogViewModel> builder) =>
      ShowsCatalogPresenter(builder: builder);
}
