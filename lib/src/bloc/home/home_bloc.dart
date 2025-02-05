import 'package:bloc/bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<HomeTabSelected>(_onChangeTab);
  }

  void _onChangeTab(HomeTabSelected event, Emitter<HomeState> emit) {
    emit(state.copyWith(tab: event.tab));
  }
}
