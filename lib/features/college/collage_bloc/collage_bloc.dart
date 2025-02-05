import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../util/file_upload.dart';
import '../../../values/strings.dart';

part 'collage_event.dart';
part 'collage_state.dart';

class CollagesBloc extends Bloc<CollagesEvent, CollagesState> {
  CollagesBloc() : super(CollagesInitialState()) {
    on<CollagesEvent>((event, emit) async {
      try {
        emit(CollagesLoadingState());
        SupabaseQueryBuilder table = Supabase.instance.client.from('collages');
        SupabaseQueryBuilder collageCourseTable =
            Supabase.instance.client.from('collage_course');
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
        } else if (event is AddCollageEvent) {
          event.collageDetails['cover_page'] = await uploadFile(
            'collages/cover_image',
            event.collageDetails['cover_image_file'],
            event.collageDetails['cover_image_name'],
          );
          event.collageDetails.remove('cover_image_file');
          event.collageDetails.remove('cover_image_name');

          await table.insert(event.collageDetails);

          emit(CollagesSuccessState());
        } else if (event is EditCollageEvent) {
          if (event.collageDetails['cover_image_file'] != null) {
            event.collageDetails['cover_page'] = await uploadFile(
              'collage/cover_image',
              event.collageDetails['cover_image_file'],
              event.collageDetails['cover_image_name'],
            );
            event.collageDetails.remove('cover_image_file');
            event.collageDetails.remove('cover_image_name');
          }

          await table.update(event.collageDetails).eq('id', event.collageId);

          emit(CollagesSuccessState());
        } else if (event is DeleteCollageEvent) {
          await table.delete().eq('id', event.collageId);
          emit(CollagesSuccessState());
        } else if (event is GetCollagesByIdEvent) {
          Map<String, dynamic> collageData = await table
              .select(
                  '''*,courses:collage_course(*,courses:university_courses(*,courses:courses(*)))''')
              .eq('id', event.collageId)
              .single();

          collageData['university_courses'] = await Supabase.instance.client
              .from('university_courses')
              .select('*,courses:courses(*)')
              .eq('university_id', collageData['university_id']);

          emit(CollagesGetByIdSuccessState(collage: collageData));
        } else if (event is AddCollageCourseEvent) {
          await collageCourseTable.insert(event.collageCourseDetails);
          emit(CollagesSuccessState());
        } else if (event is EditCollageCourseEvent) {
          await collageCourseTable
              .update(event.collageCourseDetails)
              .eq('id', event.collageCourseId);
          emit(CollagesSuccessState());
        } else if (event is DeleteCollageCourseEvent) {
          await collageCourseTable.delete().eq('id', event.collageCourseId);
          emit(CollagesSuccessState());
        }
      } catch (e, s) {
        Logger().e('$e\n$s');
        emit(CollagesFailureState());
      }
    });
  }
}
