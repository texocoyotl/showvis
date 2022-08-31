import 'package:flutter/material.dart';
import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/features/shows_catalog/domain/shows_catalog_entity.dart';
import 'package:showvis/features/shows_catalog/presentation/shows_catalog_presenter.dart';
import 'package:showvis/features/shows_catalog/presentation/shows_catalog_view_model.dart';

class ShowsCatalogUI extends UI<ShowsCatalogViewModel> {
  ShowsCatalogUI({super.key});

  @override
  Widget build(BuildContext context, ShowsCatalogViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShowVis'),
      ),
      body: _body(context, viewModel),
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
      return _successBody(context, viewModel);
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
                onPressed: viewModel.retry, child: const Text('Retry')),
          ],
        ),
      );

  Widget _loadingBody(
          BuildContext context, ShowsCatalogLoadingViewModel viewModel) =>
      const Center(child: CircularProgressIndicator());

  Widget _successBody(
          BuildContext context, ShowsCatalogSuccessViewModel viewModel) =>
      ListView(
        children: viewModel.shows
            .map((show) => _showRow(show, viewModel.openDetails))
            .toList(),
      );

  Widget _showRow(ShowSummary show, ValueChanged<int> openDetails) => Card(
        child: ListTile(
          title: Text(show.name),
          onTap: () => openDetails(show.id),
        ),
      );

  @override
  Presenter create(PresenterBuilder<ShowsCatalogViewModel> builder) =>
      ShowsCatalogPresenter(builder: builder);
}
