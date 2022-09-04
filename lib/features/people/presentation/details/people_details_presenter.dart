import 'package:intl/intl.dart';
import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/core/stateful_collections.dart';
import 'package:showvis/features/people/domain/people_entity.dart';
import 'package:showvis/features/people/domain/people_usecase.dart';
import 'package:showvis/features/people/presentation/details/people_details_view_model.dart';
import 'package:showvis/router.dart';

class PeopleDetailsPresenter
    extends Presenter<PeopleUseCase, PeopleEntity, PeopleDetailsViewModel> {
  PeopleDetailsPresenter(
      {super.key,
      required this.id,
      required PresenterBuilder<PeopleDetailsViewModel> builder})
      : super(builder: builder, provider: peopleUseCase);

  final int id;

  @override
  void onLayoutReady(context, useCase) {
    useCase.clearShows();
  }

  @override
  PeopleDetailsViewModel createViewModel(useCase, entity) {
    final person = entity.people.map[id]!;

    return PeopleDetailsViewModel(
        name: person.name,
        gender: person.gender.isEmpty ? 'Unknown' : person.gender,
        birthday: person.birthday.isAfter(DateTime.now())
            ? 'Unknown'
            : DateFormat.yMMMd().format(person.birthday),
        country: person.country.isEmpty ? 'Unknown' : person.country,
        countryCode: person.countryCode,
        imageUri: person.imageUri,
        shows: StatefulList(
            list: entity.shows.map.values.toList(), state: entity.shows.state),
        onTabChange: (index) {
          if (index == 1) useCase.fetchShows(id);
        },
        goToShow: (id) {
          router.push('/details/$id');
        });
  }
}
