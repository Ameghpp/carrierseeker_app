import 'package:carrier_seeker_app/features/course/course_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../common_widgets.dart/custom_alert_dialog.dart';
import '../../common_widgets.dart/custom_search.dart';
import '../../util/check_login.dart';
import 'courses_bloc/courses_bloc.dart';
import 'custom_course_card.dart';

class Courses extends StatefulWidget {
  const Courses({super.key});

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  final CoursesBloc _coursesBloc = CoursesBloc();

  Map<String, dynamic> params = {
    'query': null,
  };

  List<Map> _courses = [];

  @override
  void initState() {
    checkLogin(context);
    getCourses();
    super.initState();
  }

  void getCourses() {
    _coursesBloc.add(GetAllCoursesEvent(params: params));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _coursesBloc,
      child: BlocConsumer<CoursesBloc, CoursesState>(
        listener: (context, state) {
          if (state is CoursesFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Failure',
                description: state.message,
                primaryButton: 'Try Again',
                onPrimaryPressed: () {
                  getCourses();
                  Navigator.pop(context);
                },
              ),
            );
          } else if (state is CoursesGetSuccessState) {
            _courses = state.courses;
            Logger().w(_courses);
            setState(() {});
          } else if (state is CoursesSuccessState) {
            getCourses();
          }
        },
        builder: (context, state) {
          return ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 120, left: 20, right: 20),
            children: [
              Text(
                "Courses",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.black,
                    ),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomSearch(
                onSearch: (search) {
                  params['query'] = search;
                  getCourses();
                },
              ),
              const SizedBox(
                height: 20,
              ),
              if (state is CoursesLoadingState)
                const Center(child: CircularProgressIndicator()),
              if (_courses.isEmpty && state is! CoursesLoadingState)
                const Center(child: Text("No Course Found")),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                children: List.generate(
                  _courses.length,
                  (index) => CustomCourseCard(
                    image: _courses[index]['photo_url'],
                    name: _courses[index]['course_name'],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseDetailsScreen(
                            courseDetails: _courses[index],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
