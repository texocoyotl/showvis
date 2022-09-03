import 'package:showvis/core/architecture_components.dart';

class EpisodeViewModel extends ViewModel {
  final String name;
  final String season;
  final String number;
  final String summary;
  final String imageUrl;
  final String airDate;

  const EpisodeViewModel({
    required this.name,
    required this.season,
    required this.number,
    required this.summary,
    required this.imageUrl,
    required this.airDate,
  });

  @override
  List<Object?> get props => [name, season, number, summary, imageUrl, airDate];
}
