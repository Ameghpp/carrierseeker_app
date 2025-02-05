import 'package:carrier_seeker_app/common_widgets.dart/custom_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../common_widgets.dart/custom_alert_dialog.dart';
import '../../util/format_function.dart';
import 'collage_bloc/collage_bloc.dart';

class CollageDetailsScreen extends StatefulWidget {
  final int collageId;
  const CollageDetailsScreen({super.key, required this.collageId});

  @override
  State<CollageDetailsScreen> createState() => _CollageDetailsScreenState();
}

class _CollageDetailsScreenState extends State<CollageDetailsScreen> {
  final CollagesBloc _collagesBloc = CollagesBloc();

  Map<String, dynamic> _collageData = {};
  List _course = [];

  @override
  void initState() {
    getCollages();
    super.initState();
  }

  void getCollages() {
    _collagesBloc.add(GetCollagesByIdEvent(collageId: widget.collageId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      body: BlocProvider.value(
        value: _collagesBloc,
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
            } else if (collageState is CollagesGetByIdSuccessState) {
              _collageData = collageState.collage;
              _course = _collageData['courses'];
              Logger().w(_collageData);
              setState(() {});
            } else if (collageState is CollagesSuccessState) {
              getCollages();
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
                    if (state is CollagesLoadingState)
                      const LinearProgressIndicator(),
                    if (_collageData['cover_page'] != null)
                      Image.network(
                        _collageData['cover_page'],
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formatValue(_collageData['name']),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: Colors.black,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formatAddress(_collageData),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formatValue(_collageData['description']),
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
                                  name: formatValue(_course[index]?['courses']
                                      ?['courses']?['course_name']),
                                  onTap: () {},
                                ),
                              ),
                            ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
