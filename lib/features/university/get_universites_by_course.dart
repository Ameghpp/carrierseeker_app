import 'package:carrier_seeker_app/features/university/custom_university_card.dart';
import 'package:carrier_seeker_app/features/university/universitie_details.dart';
import 'package:carrier_seeker_app/util/format_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../common_widgets.dart/custom_alert_dialog.dart';
import '../../util/check_login.dart';
import 'universities_bloc/universities_bloc.dart';

class GetUniversitesByCourse extends StatefulWidget {
  final int courseID;
  const GetUniversitesByCourse({
    super.key,
    required this.courseID,
  });

  @override
  State<GetUniversitesByCourse> createState() => _GetUniversitesByCourseState();
}

class _GetUniversitesByCourseState extends State<GetUniversitesByCourse> {
  final UniversitiesBloc _universitiesBloc = UniversitiesBloc();

  Map<String, dynamic> params = {
    'query': null,
  };

  List<Map> _universities = [];

  @override
  void initState() {
    checkLogin(context);
    getUniversities();
    super.initState();
  }

  void getUniversities() {
    _universitiesBloc
        .add(GetUniversitiesByCourseIdEvent(courseId: widget.courseID));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _universitiesBloc,
      child: BlocConsumer<UniversitiesBloc, UniversitiesState>(
        listener: (context, state) {
          if (state is UniversitiesFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Failure',
                description: state.message,
                primaryButton: 'Try Again',
                onPrimaryPressed: () {
                  getUniversities();
                  Navigator.pop(context);
                },
              ),
            );
          } else if (state is UniversitiesGetSuccessState) {
            _universities = state.universities;
            Logger().w(_universities);
            setState(() {});
          } else if (state is UniversitiesSuccessState) {
            getUniversities();
          }
        },
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shrinkWrap: true,
            children: [
              Text(
                "Universities",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.black,
                    ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _universities.length,
                itemBuilder: (context, index) => CustomUniversityCard(
                  coverImageUrl: _universities[index]['cover_image'],
                  logoUrl: _universities[index]['logo'],
                  address: formatAddress(_universities[index]),
                  name: formatValue(_universities[index]['name']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UniversitieDetailsScreen(
                          universitieId: _universities[index]['id'],
                        ),
                      ),
                    );
                  },
                ),
                separatorBuilder: (context, index) => const SizedBox(
                  height: 15,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
