import 'package:flutter_bloc/flutter_bloc.dart';

part 'recetas_state.dart';

class RecetasCubit extends Cubit<RecetasState> {
  RecetasCubit() : super(const RecetasState(recetas: []));
}
