import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../values/strings.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  SigninBloc() : super(SigninInitialState()) {
    on<SigninEvent>((event, emit) async {
      try {
        emit(SigninLoadingState());

        await Supabase.instance.client.auth.signInWithPassword(
          password: event.password,
          email: event.email,
        );
        emit(SigninSuccessState());
      } catch (e, s) {
        Logger().e('$e\n$s');

        if (e is AuthException) {
          emit(SigninFailureState(message: e.message));
        } else {
          emit(SigninFailureState());
        }
      }
    });
  }
}
