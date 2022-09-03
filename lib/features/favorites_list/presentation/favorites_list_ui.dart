import 'package:flutter/material.dart';
import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/features/favorites_list/presentation/favorites_list_presenter.dart';
import 'package:showvis/features/favorites_list/presentation/favorites_list_view_model.dart';
import 'package:showvis/features/shows_catalog/presentation/catalog/shows_catalog_ui.dart';

class FavoritesListUI extends UI<FavoritesListViewModel> {
  FavoritesListUI({
    super.key,
  });

  @override
  Widget build(BuildContext context, FavoritesListViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Shows')),
      body: ListView.separated(
          itemCount: viewModel.shows.length,
          separatorBuilder: (context, _) => const Divider(),
          itemBuilder: (context, index) {
            final show = viewModel.shows[index];
            return ShowTileWidget(
              show: show,
              onTap: viewModel.openDetails,
            );
          }),
    );
  }

  @override
  Presenter create(PresenterBuilder<FavoritesListViewModel> builder) =>
      FavoritesListPresenter(builder: builder);
}
