import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/features/shows_catalog/presentation/details/sliver_app_bar.dart';
import 'package:showvis/core/stateful_collections.dart';
import 'package:showvis/features/shows_catalog/domain/shows_catalog_entity.dart';
import 'package:showvis/features/shows_catalog/presentation/details/show_details_presenter.dart';
import 'package:showvis/features/shows_catalog/presentation/details/show_details_ui.dart';
import 'package:showvis/features/shows_catalog/presentation/details/show_details_view_model.dart';
import 'package:showvis/features/shows_catalog/presentation/episode/episode_presenter.dart';
import 'package:showvis/features/shows_catalog/presentation/episode/episode_view_model.dart';

class EpisodeUI extends UI<EpisodeViewModel> {
  EpisodeUI({
    super.key,
    required this.season,
    required this.number,
  });

  final int season;
  final int number;

  @override
  Widget build(BuildContext context, EpisodeViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              '${viewModel.name} (${viewModel.season}x${viewModel.number})')),
      body: ListView(children: [
        Hero(
            tag: viewModel.imageUrl,
            child: CachedNetworkImage(imageUrl: viewModel.imageUrl)),
        Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              viewModel.summary,
              style: Theme.of(context).textTheme.bodyLarge,
            )),
        divider,
        InfoRow(label: 'Air Date:', value: viewModel.airDate),
        divider,
        const SizedBox(
          height: 24,
        ),
      ]),
    );
  }

  @override
  Presenter create(PresenterBuilder<EpisodeViewModel> builder) =>
      EpisodePresenter(season: season, number: number, builder: builder);
}
