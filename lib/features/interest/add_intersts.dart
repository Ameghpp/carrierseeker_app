import 'package:carrier_seeker_app/common_widgets.dart/custom_button.dart';
import 'package:carrier_seeker_app/features/home_screen.dart';
import 'package:carrier_seeker_app/features/interest/interests_chip.dart';
import 'package:carrier_seeker_app/util/format_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../common_widgets.dart/custom_alert_dialog.dart';
import '../../util/check_login.dart';
import 'interests_bloc/interests_bloc.dart';

class AddInterests extends StatefulWidget {
  const AddInterests({super.key});

  @override
  State<AddInterests> createState() => _AddInterestsState();
}

class _AddInterestsState extends State<AddInterests> {
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
    _interestsBloc.add(GetAllInterestsEvent(params: params));
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
            Logger().w(_interests);
            setState(() {});
          } else if (state is InterestsSuccessState) {
            getInterests();
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
                        isActive: false,
                        name: formatValue(_interests[index]['name']),
                        onTap: (isActive) {
                          if (isActive) {
                            String userID =
                                Supabase.instance.client.auth.currentUser!.id;
                            _selectedInterestIds.add({
                              'user_id': userID,
                              'interest_id': _interests[index]['id']
                            });
                          } else {
                            _selectedInterestIds.removeWhere((item) =>
                                item['interest_id'] == _interests[index]['id']);
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
                  _interestsBloc.add(
                      AddInterestsEvent(interestDetails: _selectedInterestIds));
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                      (route) => false);
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
