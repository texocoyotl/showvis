import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_sliver/extended_sliver.dart';
import 'package:flutter/material.dart';
import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/core/sliver_app_bar.dart';
import 'package:showvis/features/shows_catalog/presentation/details/show_details_presenter.dart';
import 'package:showvis/features/shows_catalog/presentation/details/show_details_view_model.dart';

class ShowDetailsUI extends UI<ShowDetailsViewModel> {
  ShowDetailsUI({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context, ShowDetailsViewModel viewModel) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          AppBarWidget(
            text: viewModel.name,
            imagePath: viewModel.largeImageUri,
            ratingsIcon: CircleAvatar(child: Text(viewModel.rating)),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    viewModel.summary,
                    style: Theme.of(context).textTheme.bodyLarge,
                  )),
              const Divider(
                height: 20,
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Genres:'),
                    Flexible(
                      child: Text(
                        viewModel.genres,
                        textAlign: TextAlign.end,
                      ),
                    )
                  ],
                ),
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Premiered:'),
                    Text(viewModel.premiered)
                  ],
                ),
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [const Text('Ended:'), Text(viewModel.ended)],
                ),
              ),
              ListTile(
                  title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Schedule:'),
                  Text('${viewModel.daysSchedule} at ${viewModel.timeSchedule}')
                ],
              )),
            ]),
          ),
        ],
      ),
    );
  }

  @override
  Presenter create(PresenterBuilder<ShowDetailsViewModel> builder) =>
      ShowDetailsPresenter(id: id, builder: builder);
}
