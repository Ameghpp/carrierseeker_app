import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../values/strings.dart';

part 'collage_event.dart';
part 'collage_state.dart';

class CollagesBloc extends Bloc<CollagesEvent, CollagesState> {
  CollagesBloc() : super(CollagesInitialState()) {
    on<CollagesEvent>((event, emit) async {
      try {
        emit(CollagesLoadingState());
        SupabaseClient supabaseClient = Supabase.instance.client;
        SupabaseQueryBuilder table = supabaseClient.from('collages');

        if (event is GetAllCollagesEvent) {
          PostgrestFilterBuilder<List<Map<String, dynamic>>> query =
              table.select('*,university:universities(id,name)');

          if (event.params['query'] != null) {
            query = query.ilike('name', '%${event.params['query']}%');
          }
          if (event.params['id'] != null) {
            query = query.eq('university_id', event.params['id']);
          }

          List<Map<String, dynamic>> collages =
              await query.order('name', ascending: true);

          emit(CollagesGetSuccessState(collages: collages));
        } else if (event is GetCollagesByIdEvent) {
          Map<String, dynamic> collageData =
              await supabaseClient.rpc('get_courses_by_college_id', params: {
            'p_college_id': event.collageId,
          });

          emit(CollagesGetByIdSuccessState(collage: collageData));
        } else if (event is GetRecommendedCollagesEvent) {
          List<Map<String, dynamic>> colalges =
              await supabaseClient.rpc('get_collages', params: {
            'p_user_id': supabaseClient.auth.currentUser!.id,
            'p_university_id': event.params['id'],
          });
          emit(RecommendedCollagesGetSuccessState(collages: colalges));
        }
      } catch (e, s) {
        Logger().e('$e\n$s');
        emit(CollagesFailureState());
      }
    });
  }
}
