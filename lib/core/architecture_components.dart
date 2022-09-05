import 'package:equatable/equatable.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The holder of the state of the features.
///
/// Each Use Case uses an Entity to add any data that needs to be propagated
/// to the outer layer.
///
/// Under this simple Clean approach, every Presenter reads the updates from
/// Entities and translate the data into a more digestable View Model.
@immutable
abstract class Entity extends Equatable {
  const Entity();

  @override
  bool get stringify => true;
}

/// Holds any business logic that modifies the state in the Entities, and links
/// any dependency behavior that creates inputs and ouputs of data.
///
/// It extends from State Notifier, so each time
/// something changes in the Entity that causes a difference in the props defined
/// thanks to the Equatable props, all subscribers receive the new instance.
///
/// It can be possible that multiple screens and widgets communicate to the same
/// Use Case, just have in consideration that this will require a Presenter / View
/// Model pair for each UI component, because each view could define specific
/// subsets of the Entity data, as well as specific callbacks caused by UI events
/// and user interactions.
abstract class UseCase<E extends Entity> extends StateNotifier<E> {
  UseCase({required E entity}) : super(entity);

  @visibleForTesting
  @protected
  E get entity => super.state;

  @protected
  set entity(newEntity) => super.state = newEntity;
}

/// Based on the Riverpod providers, this encapsulates most of the hard-to-understand
/// setup code. This class will let the developers get the use case references
/// with or without a context and listen to entity changes.
class UseCaseProvider<E extends Entity, U extends UseCase<E>> {
  final StateNotifierProvider<U, E> _provider;
  final U Function(Ref) create;

  UseCaseProvider(this.create)
      : _provider = StateNotifierProvider<U, E>(create);

  U getUseCase(WidgetRef ref) => ref.watch(_provider.notifier);

  U getUseCaseFromContext(ProviderContainer container) {
    return container.read(_provider.notifier);
  }

  E subscribe(WidgetRef ref) {
    return ref.watch(_listenForChanges(ref));
  }

  void listen(WidgetRef ref, void Function(E?, E) listener) {
    ref.listen<E>(_listenForChanges(ref), listener);
  }

  AlwaysAliveProviderListenable<E> _listenForChanges(
    WidgetRef ref,
  ) {
    final useCase = getUseCase(ref);
    return _provider.select((e) => useCase.entity);
  }
}

typedef ProviderListener<E extends Entity> = void Function(E entity);

/// A View Model should be responsible to propagate only the data from the Entities
/// that makes sense for the UI component attached to it. It also becomes the holder
/// of any callback related to user interaction. This way, the is no need for UI clases
/// to have a reference to the Use Case.
///
/// Try to have already formated data in this class. For example, date fields should
/// already have been translated into a text version and be passed as Strings through
/// this class.
@immutable
abstract class ViewModel extends Equatable {
  const ViewModel();
}

/// For each UI component that will interact with a specific View Model, a Presenter
/// needs to exist as the middleman that "translates" the raw data from Entities.
///
/// The two helper methods [onLayoutReady] and [onUpdate] are optionally used
/// if a flow of logic not only depends on simple updates from Entities.
///
/// [onLayourReady] will be called once the Presenter is inserted on the Widget tree,
/// so it is used for calls that trigger some kind of setup on the Use Case.
///
/// [onUpdate] will matter when the updates do something tha requires a BuildContext.
abstract class Presenter<U extends UseCase, E extends Entity,
    V extends ViewModel> extends ConsumerStatefulWidget {
  final UseCaseProvider _provider;
  final PresenterBuilder<V> builder;

  const Presenter(
      {super.key, required UseCaseProvider provider, required this.builder})
      : _provider = provider;

  @override
  // ignore: library_private_types_in_public_api
  _PresenterState<U, E, V> createState() => _PresenterState<U, E, V>();

  @protected
  V createViewModel(U useCase, E entity);

  /// Called when this presenter is inserted into the tree.
  @protected
  void onLayoutReady(BuildContext context, U useCase) {}

  /// Called whenever the [output] updates.
  @protected
  void onUpdate(BuildContext context, E entity) {}

  /// Called whenever the presenter configuration changes.
  @protected
  void didUpdatePresenter(
    BuildContext context,
    covariant Presenter<U, E, V> old,
    U useCase,
  ) {}

  /// Called when this presenter is removed from the tree.
  @protected
  void onDestroy(U useCase) {}

  E subscribe(WidgetRef ref) => _provider.subscribe(ref) as E;
}

// ignore: library_private_types_in_public_api
class _PresenterState<U extends UseCase, E extends Entity, V extends ViewModel>
    extends ConsumerState<Presenter<U, E, V>> {
  U? _useCase;

  @override
  WidgetRef get ref => context as WidgetRef;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      widget.onLayoutReady(context, _useCase!);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _useCase ??= widget._provider.getUseCase(ref) as U;
  }

  @override
  void didUpdateWidget(covariant Presenter<U, E, V> oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.didUpdatePresenter(context, oldWidget, _useCase!);
  }

  @override
  Widget build(BuildContext context) {
    widget._provider.listen(ref, _onChange);
    final output = widget.subscribe(ref);
    return widget.builder(widget.createViewModel(_useCase!, output));
  }

  void _onChange(previous, next) {
    if (previous != next) widget.onUpdate(context, next);
  }

  @override
  void dispose() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      widget.onDestroy(_useCase!);
    });
    super.dispose();
  }
}

typedef PresenterBuilder<V extends ViewModel> = Widget Function(V viewModel);

/// A widget class that is coupled with a View Model.
///
/// When using this class, avoid any code that either generates states (as with
/// the basic Stateful Widgets code normally found in the web) or that has
/// manipulation or format logic.
abstract class UI<V extends ViewModel> extends StatefulWidget {
  late final PresenterCreator<V>? _create;
  UI({
    Key? key,
    PresenterCreator<V>? create,
  }) : super(key: key) {
    _create = create ?? this.create;
  }

  Widget build(BuildContext context, V viewModel);

  Presenter create(PresenterBuilder<V> builder);

  @override
  // ignore: library_private_types_in_public_api
  _UIState createState() => _UIState<V>();
}

class _UIState<V extends ViewModel> extends State<UI<V>> {
  @override
  Widget build(BuildContext context) {
    return widget._create!
        .call((viewModel) => widget.build(context, viewModel));
  }
}

typedef PresenterCreator<V extends ViewModel> = Presenter Function(
    PresenterBuilder<V> builder);
