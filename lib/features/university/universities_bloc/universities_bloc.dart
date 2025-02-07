import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../values/strings.dart';

part 'universities_event.dart';
part 'universities_state.dart';

class UniversitiesBloc extends Bloc<UniversitiesEvent, UniversitiesState> {
  UniversitiesBloc() : super(UniversitiesInitialState()) {
    on<UniversitiesEvent>((event, emit) async {
      try {
        emit(UniversitiesLoadingState());
        SupabaseClient supabaseClient = Supabase.instance.client;

        SupabaseQueryBuilder table = supabaseClient.from('universities');

        if (event is GetAllUniversitiesEvent) {
          PostgrestFilterBuilder<List<Map<String, dynamic>>> query =
              table.select('*');

          if (event.params['query'] != null) {
            query = query.ilike('name', '%${event.params['query']}%');
          }

          List<Map<String, dynamic>> universities =
              await query.order('name', ascending: true);

          emit(UniversitiesGetSuccessState(universities: universities));
        } else if (event is GetUniversitiesByIdEvent) {
          Map<String, dynamic> universitieData = await table
              .select(
                  '''*,courses:university_courses(*,courses:course_id(*))''')
              .eq('id', event.universitieId)
              .single();
          emit(UniversitiesGetByIdSuccessState(universities: universitieData));
        } else if (event is GetRecommendedUniversitiesEvent) {
          List<Map<String, dynamic>> universities = [];
          if (event.params['query'] != null) {
            universities =
                await supabaseClient.rpc('get_universities', params: {
              'p_user_id': supabaseClient.auth.currentUser!.id,
              'search_term': event.params['query']
            });
          } else {
            universities = await supabaseClient.rpc('get_universities',
                params: {'p_user_id': supabaseClient.auth.currentUser!.id});
          }

          emit(RecommendedUniversitiesGetSuccessState(
              universities: universities));
        } else if (event is GetUniversitiesByCourseIdEvent) {
          List<Map<String, dynamic>> universities = await supabaseClient.rpc(
              'get_universities_by_course_id',
              params: {'p_course_id': event.courseId});
          emit(UniversitiesGetSuccessState(universities: universities));
        }
      } catch (e, s) {
        Logger().e('$e\n$s');
        emit(UniversitiesFailureState());
      }
    });
  }
}
