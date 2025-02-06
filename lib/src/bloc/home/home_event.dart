part of 'home_bloc.dart';

sealed class HomeEvent implements Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];

  @override
  bool get stringify => true;
}

final class HomeTabChanged extends HomeEvent {
  final int tab;

  const HomeTabChanged(this.tab);

  @override
  List<Object> get props => [tab];
}
