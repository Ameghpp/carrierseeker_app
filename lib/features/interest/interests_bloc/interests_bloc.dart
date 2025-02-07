import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../values/strings.dart';

part 'interests_event.dart';
part 'interests_state.dart';

class InterestsBloc extends Bloc<InterestsEvent, InterestsState> {
  InterestsBloc() : super(InterestsInitialState()) {
    on<InterestsEvent>((event, emit) async {
      try {
        emit(InterestsLoadingState());
        SupabaseClient supabaseClient = Supabase.instance.client;
        SupabaseQueryBuilder table = supabaseClient.from('user_interests');

        if (event is GetAllUserInterestsEvent) {
          List<Map<String, dynamic>> interests = await supabaseClient.rpc(
              'get_user_interests',
              params: {'p_user_id': supabaseClient.auth.currentUser!.id});

          emit(InterestsGetSuccessState(interests: interests));
        } else if (event is GetAllInterestsEvent) {
          List<Map<String, dynamic>> interests =
              await supabaseClient.from('interests').select('*').order('name');

          emit(InterestsGetSuccessState(interests: interests));
        } else if (event is AddInterestsEvent) {
          await table.insert(event.interestDetails);

          emit(InterestsSuccessState());
        } else if (event is EditInterestsEvent) {
          await table
              .delete()
              .eq('user_id', supabaseClient.auth.currentUser!.id);

          await table.insert(event.interestDetails);

          emit(InterestsSuccessState());
        }
      } catch (e, s) {
        Logger().e('$e\n$s');
        emit(InterestsFailureState());
      }
    });
  }
}
