import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/core/stateful_collections.dart';
import 'package:showvis/features/people/domain/people_entity.dart';
import 'package:showvis/features/people/domain/people_usecase.dart';
import 'package:showvis/features/people/presentation/search/people_search_view_model.dart';

class PeopleSearchPresenter
    extends Presenter<PeopleUseCase, PeopleEntity, PeopleSearchViewModel> {
  PeopleSearchPresenter(
      {super.key, required PresenterBuilder<PeopleSearchViewModel> builder})
      : super(builder: builder, provider: peopleUseCase);

  @override
  PeopleSearchViewModel createViewModel(
      PeopleUseCase useCase, PeopleEntity entity) {
    return PeopleSearchViewModel(
      people: StatefulList(
          list: entity.people.map.values.toList(), state: entity.people.state),
      search: useCase.searchPeople,
      cancelSearch: useCase.cancelSearch,
      openDetails: (_) {},
    );
  }
}
