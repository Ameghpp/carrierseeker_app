import 'package:carrier_seeker_app/common_widgets.dart/custom_button.dart';
import 'package:carrier_seeker_app/features/interest/interests_chip.dart';
import 'package:carrier_seeker_app/util/format_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../common_widgets.dart/custom_alert_dialog.dart';
import '../../util/check_login.dart';
import 'interests_bloc/interests_bloc.dart';

class Interests extends StatefulWidget {
  const Interests({super.key});

  @override
  State<Interests> createState() => _InterestsState();
}

class _InterestsState extends State<Interests> {
  final InterestsBloc _interestsBloc = InterestsBloc();

  Map<String, dynamic> params = {
    'query': null,
  };

  List<Map<String, dynamic>> _interests = [], _selectedInterestIds = [];

  @override
  void initState() {
    checkLogin(context);
    getInterests();
    super.initState();
  }

  void getInterests() {
    _interestsBloc.add(GetAllUserInterestsEvent(params: params));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _interestsBloc,
      child: BlocConsumer<InterestsBloc, InterestsState>(
        listener: (context, state) {
          if (state is InterestsFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Failure',
                description: state.message,
                primaryButton: 'Try Again',
                onPrimaryPressed: () {
                  getInterests();
                  Navigator.pop(context);
                },
              ),
            );
          } else if (state is InterestsGetSuccessState) {
            _interests = state.interests;
            _selectedInterestIds = _interests
                .where((interest) => interest['is_selected'] == true)
                .map((interest) => {
                      'user_id': interest['user_id'],
                      'interest_id': interest['interest_id']
                    })
                .toList();
            Logger().w(_interests);
            setState(() {});
          } else if (state is InterestsSuccessState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: SafeArea(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  Text(
                    "Select your Interests",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.black,
                        ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (state is InterestsLoadingState)
                    const Center(child: CircularProgressIndicator()),
                  if (_interests.isEmpty && state is! InterestsLoadingState)
                    const Center(child: Text("No Interests Found")),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    children: List.generate(
                      _interests.length,
                      (index) => InterestsChip(
                        isActive: _interests[index]['is_selected'],
                        name: formatValue(_interests[index]['interest_name']),
                        onTap: (isActive) {
                          if (isActive) {
                            _selectedInterestIds.add({
                              'user_id': _interests[index]['user_id'],
                              'interest_id': _interests[index]['interest_id']
                            });
                          } else {
                            _selectedInterestIds.removeWhere((item) =>
                                item['user_id'] ==
                                    _interests[index]['user_id'] &&
                                item['interest_id'] ==
                                    _interests[index]['interest_id']);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                onPressed: () {
                  _interestsBloc.add(EditInterestsEvent(
                      interestDetails: _selectedInterestIds));
                },
                label: 'Save',
              ),
            ),
          );
        },
      ),
    );
  }
}
