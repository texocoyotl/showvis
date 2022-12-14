import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/core/models.dart';
import 'package:showvis/features/shows_catalog/presentation/catalog/shows_catalog_ui.dart';
import 'package:showvis/features/shows_catalog/presentation/details/shows_app_bar_widget.dart';
import 'package:showvis/core/stateful_collections.dart';
import 'package:showvis/features/shows_catalog/domain/shows_catalog_entity.dart';
import 'package:showvis/features/shows_catalog/presentation/details/show_details_presenter.dart';
import 'package:showvis/features/shows_catalog/presentation/details/show_details_view_model.dart';
import 'package:showvis/router.dart';

class ShowDetailsUI extends UI<ShowDetailsViewModel> {
  ShowDetailsUI({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context, ShowDetailsViewModel viewModel) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              ShowsAppBarWidget(
                text: viewModel.name,
                imagePath: viewModel.largeImageUri,
                ratingsIcon: ShowRatingWidget(rating: viewModel.rating),
                onTabChange: viewModel.onTabChange,
                isFavorite: viewModel.isFavorite,
                toggleFavorite: viewModel.toggleFavorite,
              )
            ];
          },
          body: TabBarView(children: [
            ShowInfoWidget(viewModel: viewModel),
            EpisodesWidget(viewModel: viewModel),
          ]),
        ),
      ),
    );
  }

  @override
  Presenter create(PresenterBuilder<ShowDetailsViewModel> builder) =>
      ShowDetailsPresenter(id: id, builder: builder);
}

const divider = Divider(
  thickness: 1.5,
  height: 20,
);

class ShowInfoWidget extends StatelessWidget {
  const ShowInfoWidget({super.key, required this.viewModel});

  final ShowDetailsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            viewModel.summary,
            style: Theme.of(context).textTheme.bodyLarge,
          )),
      divider,
      InfoRow(label: 'Genres:', value: viewModel.genres),
      divider,
      InfoRow(label: 'Premiered:', value: viewModel.premiered),
      divider,
      InfoRow(label: 'Ended:', value: viewModel.ended),
      divider,
      InfoRow(
          label: 'Schedule:',
          value: '${viewModel.daysSchedule} at ${viewModel.timeSchedule}'),
      divider,
      const SizedBox(
        height: 24,
      ),
    ]);
  }
}

class EpisodesWidget extends StatelessWidget {
  const EpisodesWidget({super.key, required this.viewModel});

  final ShowDetailsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.episodes.state == CollectionState.initial) {
      return Container();
    } else if (viewModel.episodes.state == CollectionState.loading) {
      return const Center(
        child: CupertinoActivityIndicator(
          radius: 24,
          color: Colors.black87,
        ),
      );
    } else if (viewModel.episodes.state == CollectionState.networkError) {
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
    return ListView.builder(
      itemCount: viewModel.episodes.map.length,
      itemBuilder: (context, index) {
        final season = viewModel.episodes.map.keys.elementAt(index);
        return ExpansionTile(
          initiallyExpanded: index == 0,
          title: Text('Season $season'),
          children: [
            for (Episode episode in viewModel.episodes.map[season].values)
              ListTile(
                leading: SizedBox(
                    height: 50,
                    width: 50,
                    child: Hero(
                      tag: episode.imageUrl,
                      child: episode.imageUrl.isEmpty
                          ? const Image(
                              image: AssetImage('assets/no_image.png'))
                          : CachedNetworkImage(
                              imageUrl: episode.imageUrl,
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      const CupertinoActivityIndicator(
                                radius: 16,
                                color: Colors.black87,
                              ),
                            ),
                    )),
                title: Text('${episode.number} - ${episode.name}'),
                onTap: () {
                  router.push('/episode/${episode.season}/${episode.number}');
                },
              )
          ],
        );
      },
    );
  }
}

class InfoRow extends StatelessWidget {
  const InfoRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.bodyMedium),
          )
        ],
      ),
    );
  }
}
