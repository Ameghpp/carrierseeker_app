import 'package:carrier_seeker_app/features/recommended/recommended_universitie_details.dart';
import 'package:carrier_seeker_app/features/university/custom_university_card.dart';
import 'package:carrier_seeker_app/theme/app_theme.dart';
import 'package:carrier_seeker_app/util/format_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../common_widgets.dart/custom_alert_dialog.dart';
import '../../common_widgets.dart/custom_search.dart';
import '../../util/check_login.dart';
import '../university/universities_bloc/universities_bloc.dart';

class RecommendedUniversitie extends StatefulWidget {
  const RecommendedUniversitie({
    super.key,
  });

  @override
  State<RecommendedUniversitie> createState() => _RecommendedUniversitieState();
}

class _RecommendedUniversitieState extends State<RecommendedUniversitie> {
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
    _universitiesBloc.add(GetRecommendedUniversitiesEvent(params: params));
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
          } else if (state is RecommendedUniversitiesGetSuccessState) {
            _universities = state.universities;
            Logger().w(_universities);
            setState(() {});
          } else if (state is UniversitiesSuccessState) {
            getUniversities();
          }
        },
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.only(bottom: 120, left: 20, right: 20),
            shrinkWrap: true,
            children: [
              Text(
                "Recommended Universities",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: onSurfaceColor, fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomSearch(
                onSearch: (search) {
                  params['query'] = search;
                  getUniversities();
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _universities.length,
                itemBuilder: (context, index) =>
                    _universities[index]['cover_image'] != null
                        ? CustomUniversityCard(
                            coverImageUrl: _universities[index]['cover_image'],
                            logoUrl: _universities[index]['logo'],
                            address: formatAddress(_universities[index]),
                            name: formatValue(_universities[index]['name']),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RecommendedUniversitieDetails(
                                    universitieId: _universities[index]['id'],
                                  ),
                                ),
                              );
                            },
                          )
                        : SizedBox(),
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
