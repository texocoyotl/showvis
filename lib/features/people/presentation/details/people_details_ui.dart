import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/core/stateful_collections.dart';
import 'package:showvis/features/people/presentation/details/people_app_bar_widget.dart';
import 'package:showvis/features/people/presentation/details/people_details_presenter.dart';
import 'package:showvis/features/people/presentation/details/people_details_view_model.dart';
import 'package:showvis/features/shows_catalog/presentation/catalog/shows_catalog_ui.dart';
import 'package:showvis/features/shows_catalog/presentation/details/show_details_ui.dart';

class PeopleDetailsUI extends UI<PeopleDetailsViewModel> {
  PeopleDetailsUI({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context, PeopleDetailsViewModel viewModel) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              PeopleAppBarWidget(
                text: viewModel.name,
                imagePath: viewModel.imageUri,
                onTabChange: viewModel.onTabChange,
              )
            ];
          },
          body: TabBarView(children: [
            PersonInfoWidget(viewModel: viewModel),
            ShowsWidget(viewModel: viewModel),
          ]),
        ),
      ),
    );
  }

  @override
  Presenter create(PresenterBuilder<PeopleDetailsViewModel> builder) =>
      PeopleDetailsPresenter(id: id, builder: builder);
}

const divider = Divider(
  thickness: 1.5,
  height: 20,
);

class PersonInfoWidget extends StatelessWidget {
  const PersonInfoWidget({super.key, required this.viewModel});

  final PeopleDetailsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      InfoRow(label: 'Gender:', value: viewModel.gender),
      divider,
      InfoRow(label: 'Birthday:', value: viewModel.birthday),
      divider,
      InfoRow(label: 'Country:', value: viewModel.country),
      divider,
      const SizedBox(
        height: 24,
      ),
    ]);
  }
}

class ShowsWidget extends StatelessWidget {
  const ShowsWidget({super.key, required this.viewModel});

  final PeopleDetailsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.shows.state == CollectionState.initial) {
      return Container();
    } else if (viewModel.shows.state == CollectionState.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (viewModel.shows.state == CollectionState.networkError) {
      return Center(
        child: Column(
          children: [
            const Text(
                'The list cannot be retrieved at this moment, please check you have Internet connection.'),
            ElevatedButton(
                onPressed: () => viewModel.onTabChange(1),
                child: const Text('Retry')),
          ],
        ),
      );
    }
    return viewModel.shows.list.isEmpty
        ? _noShows(context)
        : ListView.separated(
            itemCount: viewModel.shows.list.length,
            separatorBuilder: (context, _) => const Divider(),
            itemBuilder: (context, index) {
              final show = viewModel.shows.list[index];
              return ShowTileWidget(
                show: show,
                onTap: viewModel.goToShow,
              );
            },
          );
  }

  Widget _noShows(BuildContext context) => Center(
        child: SizedBox(
          width: 200,
          child: Text(
            'There are no shows related to this person',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
        ),
      );
}
