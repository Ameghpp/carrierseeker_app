import 'package:carrier_seeker_app/common_widgets.dart/custom_chip.dart';
import 'package:carrier_seeker_app/features/college/collage_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../common_widgets.dart/custom_alert_dialog.dart';
import '../../util/format_function.dart';
import '../college/collage_bloc/collage_bloc.dart';
import '../college/custom_collage_card.dart';
import 'universities_bloc/universities_bloc.dart';

class UniversitieDetailsScreen extends StatefulWidget {
  final int universitieId;
  const UniversitieDetailsScreen({super.key, required this.universitieId});

  @override
  State<UniversitieDetailsScreen> createState() =>
      _UniversitieDetailsScreenState();
}

class _UniversitieDetailsScreenState extends State<UniversitieDetailsScreen> {
  final UniversitiesBloc _universitiesBloc = UniversitiesBloc();
  final CollagesBloc _collagesBloc = CollagesBloc();

  Map<String, dynamic> _universitieData = {};
  List _course = [], _collages = [];

  @override
  void initState() {
    getCollages();
    getUniversities();
    super.initState();
  }

  void getUniversities() {
    _universitiesBloc
        .add(GetUniversitiesByIdEvent(universitieId: widget.universitieId));
  }

  void getCollages() {
    _collagesBloc
        .add(GetAllCollagesEvent(params: {'id': widget.universitieId}));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: _universitiesBloc,
            ),
            BlocProvider.value(
              value: _collagesBloc,
            ),
          ],
          child: BlocConsumer<CollagesBloc, CollagesState>(
            listener: (context, collageState) {
              if (collageState is CollagesFailureState) {
                showDialog(
                  context: context,
                  builder: (context) => CustomAlertDialog(
                    title: 'Failure',
                    description: collageState.message,
                    primaryButton: 'Try Again',
                    onPrimaryPressed: () {
                      getCollages();
                      Navigator.pop(context);
                    },
                  ),
                );
                //todo
              } else if (collageState is CollagesGetSuccessState) {
                _collages = collageState.collages;
                Logger().w(_collages);
                setState(() {});
              } else if (collageState is CollagesSuccessState) {
                getCollages();
              }
            },
            builder: (context, collageState) {
              return BlocConsumer<UniversitiesBloc, UniversitiesState>(
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
                  } else if (state is UniversitiesGetByIdSuccessState) {
                    _universitieData = state.universities;
                    _course = state.universities['courses'];
                    Logger().w(_universitieData);
                    setState(() {});
                  } else if (state is UniversitiesSuccessState) {
                    getUniversities();
                  }
                },
                builder: (context, state) {
                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 900,
                      ),
                      child: ListView(
                        children: [
                          if (state is UniversitiesLoadingState)
                            const LinearProgressIndicator(),
                          if (_universitieData['cover_image'] != null)
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Image.network(
                                  _universitieData['cover_image'],
                                  height: 250,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                                if (_universitieData['logo'] != null)
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                        _universitieData['logo'],
                                      ),
                                      backgroundColor: Colors.grey[200],
                                    ),
                                  ),
                              ],
                            ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  formatValue(_universitieData['name']),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: Colors.black,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formatAddress(_universitieData),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[700],
                                      ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Courses",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: Colors.black,
                                      ),
                                ),
                                if (_course.isNotEmpty)
                                  const SizedBox(
                                    height: 10,
                                  ),
                                if (_course.isNotEmpty)
                                  Wrap(
                                    runSpacing: 20,
                                    spacing: 20,
                                    children: List.generate(
                                      _course.length,
                                      (index) => CustomChip(
                                        name: formatValue(_course[index]
                                            ?['courses']?['course_name']),
                                        onTap: () {},
                                      ),
                                    ),
                                  ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Colleges",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: Colors.black,
                                      ),
                                ),
                                if (_collages.isNotEmpty)
                                  const SizedBox(
                                    height: 10,
                                  ),
                                if (_collages.isNotEmpty)
                                  Wrap(
                                    runSpacing: 20,
                                    spacing: 20,
                                    children: List.generate(
                                      _collages.length,
                                      (index) => CustomCollageCard(
                                        coverImageUrl: _collages[index]
                                            ['cover_page'],
                                        name: _collages[index]['name'],
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CollageDetailsScreen(
                                                collageId: _collages[index]
                                                    ['id'],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
