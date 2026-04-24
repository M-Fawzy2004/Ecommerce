import 'package:flutter_bloc/flutter_bloc.dart';

/// A base Cubit that prevents emitting states after the cubit is closed.
/// This prevents "StateError (Bad state: Cannot emit new states after calling close)"
abstract class BaseCubit<State> extends Cubit<State> {
  BaseCubit(super.initialState);

  @override
  void emit(State state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
