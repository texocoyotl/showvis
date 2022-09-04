import 'package:app_bar_with_search_switch/app_bar_with_search_switch.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/core/models.dart';
import 'package:showvis/core/stateful_collections.dart';
import 'package:showvis/features/people/presentation/search/people_search_presenter.dart';
import 'package:showvis/features/people/presentation/search/people_search_view_model.dart';

class PeopleSearchUI extends UI<PeopleSearchViewModel> {
  PeopleSearchUI({super.key});

  final searchText = ValueNotifier<String>('');

  @override
  Widget build(BuildContext context, PeopleSearchViewModel viewModel) {
    final isSearchMode = ValueNotifier<bool>(true);

    Widget content = Container();
    if (searchText.value.isEmpty && viewModel.people.list.isEmpty) {
      content = _beforeSearch(context);
    } else if (viewModel.people.state == CollectionState.loading) {
      content = _loading();
    } else if (viewModel.people.state == CollectionState.networkError) {
      content = _error(context);
    } else if (viewModel.people.state == CollectionState.populated) {
      content = _list(viewModel);
    }

    return Scaffold(
      appBar: _appBar(viewModel, searchText, isSearchMode),
      body: content,
    );
  }

  _appBar(PeopleSearchViewModel viewModel, searchText, isSearchMode) =>
      AppBarWithSearchSwitch(
        customIsSearchModeNotifier: isSearchMode,
        customTextNotifier: searchText,
        closeOnSubmit: false,
        clearOnSubmit: false,
        clearOnClose: true,
        onSubmitted: viewModel.search,
        onClosed: viewModel.cancelSearch,
        appBarBuilder: (context) {
          return AppBar(
            title: const Text('People'),
            actions: const [
              AppBarSearchButton(
                buttonHasTwoStates: false,
              ),
            ],
          );
        },
      );

  Widget _beforeSearch(BuildContext context) => Center(
        child: SizedBox(
          width: 200,
          child: Text(
            'Find your favorite actor or actress by name using the Search Bar',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
        ),
      );

  Widget _loading() => const Center(
        child: CircularProgressIndicator(),
      );

  Widget _error(BuildContext context) => Center(
          child: SizedBox(
        width: 200,
        child: Text(
          'The list cannot be retrieved at this moment, please check that you have Internet connection.',
          style: Theme.of(context).textTheme.headline5,
          textAlign: TextAlign.center,
        ),
      ));

  Widget _list(PeopleSearchViewModel viewModel) => ListView.separated(
      itemCount: viewModel.people.list.length,
      separatorBuilder: (context, _) => const Divider(),
      itemBuilder: (context, index) {
        final person = viewModel.people.list[index];
        return PersonTileWidget(person: person, onTap: viewModel.openDetails);
      });

  @override
  Presenter create(PresenterBuilder<PeopleSearchViewModel> builder) =>
      PeopleSearchPresenter(builder: builder);
}

class PersonTileWidget extends StatelessWidget {
  const PersonTileWidget(
      {super.key, required this.person, required this.onTap});

  final Person person;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Hero(
        tag: person.name,
        child: person.imageUri.isEmpty
            ? const Image(image: AssetImage('assets/no_image.png'))
            : CachedNetworkImage(
                imageUrl: person.imageUri,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    const CupertinoActivityIndicator(
                  radius: 10,
                  //value: downloadProgress.progress,
                  color: Colors.black87,
                ),
                height: 150,
              ),
      ),
      title: Text(person.name),
      onTap: () => onTap(person.id),
    );
  }
}
