import 'package:app_bar_with_search_switch/app_bar_with_search_switch.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/core/models.dart';

import 'package:showvis/features/shows_catalog/presentation/catalog/shows_catalog_presenter.dart';
import 'package:showvis/features/shows_catalog/presentation/catalog/shows_catalog_view_model.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';

class ShowsCatalogUI extends UI<ShowsCatalogViewModel> {
  ShowsCatalogUI({super.key});

  @override
  Widget build(BuildContext context, ShowsCatalogViewModel viewModel) {
    final searchText = ValueNotifier<String>('');

    final isSearchMode = ValueNotifier<bool>((viewModel.fromSearch));
    return WillPopScope(
      // On Android devices, the app bar won't detect the back button event
      // when the search is active, so it has to be consumed by this widget
      onWillPop: () async {
        if (searchText.value != '') {
          isSearchMode.value = false;
          searchText.value = '';
          viewModel.refresh();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: _appBar(viewModel, searchText, isSearchMode),
        body: _body(context, viewModel),
      ),
    );
  }

  _appBar(ShowsCatalogViewModel viewModel, searchText, isSearchMode) =>
      AppBarWithSearchSwitch(
        customIsSearchModeNotifier: isSearchMode,
        customTextNotifier: searchText,
        closeOnSubmit: false,
        clearOnSubmit: false,
        clearOnClose: true,
        onSubmitted: viewModel.search,
        onClosed: viewModel.refresh,
        appBarBuilder: (context) {
          return AppBar(
            title: const Text('All Shows'),
            actions: const [
              AppBarSearchButton(
                buttonHasTwoStates: false,
              ),
            ],
          );
        },
      );

  Widget _body(
    BuildContext context,
    ShowsCatalogViewModel viewModel,
  ) {
    return InfiniteList(
      itemCount: viewModel.shows.length,
      isLoading: viewModel.isLoading,
      hasError: viewModel.hasError,
      onFetchData: !viewModel.fromSearch ? viewModel.goToNextPage : () {},
      separatorBuilder: (context) => const Divider(),
      itemBuilder: (context, index) {
        return ShowTileWidget(
            show: viewModel.shows[index], onTap: viewModel.openDetails);
      },
      errorBuilder: (context) {
        return Column(
          children: [
            const Text(
                'The list cannot be retrieved at this moment, please check that you have Internet connection.'),
            ElevatedButton(
                onPressed: viewModel.refresh, child: const Text('Retry')),
          ],
        );
      },
    );
  }

  @override
  Presenter create(PresenterBuilder<ShowsCatalogViewModel> builder) =>
      ShowsCatalogPresenter(builder: builder);
}

class ShowTileWidget extends StatelessWidget {
  const ShowTileWidget({super.key, required this.show, required this.onTap});

  final Show show;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Hero(
        tag: show.name,
        child: show.largeImageUri.isEmpty
            ? const Image(image: AssetImage('assets/no_image.png'))
            : CachedNetworkImage(
                imageUrl: show.largeImageUri,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    const CupertinoActivityIndicator(
                  radius: 10,
                  //value: downloadProgress.progress,
                  color: Colors.black87,
                ),
                height: 150,
              ),
      ),
      title: Text(show.name),
      trailing: ShowRatingWidget(rating: show.rating.toString()),
      onTap: () => onTap(show.id),
    );
  }
}

class ShowRatingWidget extends StatelessWidget {
  const ShowRatingWidget({super.key, required this.rating});

  final String rating;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      width: 64,
      child: Stack(alignment: Alignment.center, children: [
        const Center(child: Icon(Icons.star, color: Colors.yellow, size: 54)),
        Center(
            child: Text(
          rating,
          style: const TextStyle(color: Colors.black),
        ))
      ]),
    );
  }
}
