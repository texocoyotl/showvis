import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/core/sliver_app_bar.dart';
import 'package:showvis/core/stateful_collections.dart';
import 'package:showvis/features/shows_catalog/domain/shows_catalog_entity.dart';
import 'package:showvis/features/shows_catalog/presentation/details/show_details_presenter.dart';
import 'package:showvis/features/shows_catalog/presentation/details/show_details_view_model.dart';

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
              AppBarWidget(
                text: viewModel.name,
                imagePath: viewModel.largeImageUri,
                ratingsIcon: CircleAvatar(child: Text(viewModel.rating)),
                onTabChange: viewModel.onTabChange,
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
      ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Genres:', style: Theme.of(context).textTheme.bodyLarge),
            Flexible(
              child: Text(viewModel.genres,
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.bodyMedium),
            )
          ],
        ),
      ),
      divider,
      ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Premiered:', style: Theme.of(context).textTheme.bodyLarge),
            Text(viewModel.premiered)
          ],
        ),
      ),
      divider,
      ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Ended:', style: Theme.of(context).textTheme.bodyLarge),
            Text(viewModel.ended),
          ],
        ),
      ),
      divider,
      ListTile(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Schedule:', style: Theme.of(context).textTheme.bodyLarge),
          Text('${viewModel.daysSchedule} at ${viewModel.timeSchedule}'),
        ],
      )),
      divider,
      const SizedBox(
        height: 24,
      ),
      // ExpansionTile(
      //   title: const Text('Episodes'),
      //   children: viewModel.episodes.state == CollectionState.initial ||
      //           viewModel.episodes.state == CollectionState.loading
      //       ? [
      //           const Center(
      //             child: CupertinoActivityIndicator(
      //               radius: 24,
      //               color: Colors.black87,
      //             ),
      //           )
      //         ]
      //       : [
      //           for (Episode episode in viewModel.episodes.map.values)
      //             Text(episode.name)
      //         ],
      // ),
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
        return ExpansionTile(
          initiallyExpanded: index == 0,
          title: Text('Season ${index + 1}'),
          children: [
            for (Episode episode in viewModel.episodes
                .map[viewModel.episodes.map.keys.elementAt(index)].values)
              ListTile(
                leading: SizedBox(
                    height: 50,
                    width: 50,
                    child: CachedNetworkImage(
                      imageUrl: episode.imageUrl,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              const CupertinoActivityIndicator(
                        radius: 16,
                        //value: downloadProgress.progress,
                        color: Colors.black87,
                      ),
                    )),
                title: Text('${episode.number} - ${episode.name}'),
                subtitle: Text(episode.airDate.day.toString()),
              )
          ],
        );
      },
    );
  }
}
