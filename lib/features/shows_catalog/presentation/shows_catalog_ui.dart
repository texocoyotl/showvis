import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:showvis/core/architecture_components.dart';
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
      body: Text(viewModel.shows.length.toString()),
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.fetchShows,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  Presenter create(PresenterBuilder<ShowsCatalogViewModel> builder) =>
      ShowsCatalogPresenter(builder: builder);
}
