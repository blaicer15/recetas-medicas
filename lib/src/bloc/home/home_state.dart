part of 'home_bloc.dart';

final class HomeState extends Equatable {
  final int tab;

  const HomeState({this.tab = 0});

  @override
  List<Object?> get props => [tab];

  HomeState copyWith({
    int? tab,
  }) {
    return HomeState(
      tab: tab ?? this.tab,
    );
  }
}
