import 'package:carrier_seeker_app/common_widgets.dart/custom_button.dart';
import 'package:carrier_seeker_app/common_widgets.dart/custom_chip.dart';
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

  List<Map> _interests = [];

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
            body: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1320),
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
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
                      spacing: 20,
                      runSpacing: 20,
                      alignment: WrapAlignment.start,
                      runAlignment: WrapAlignment.start,
                      children: List.generate(
                        _interests.length,
                        (index) => CustomChip(
                          name: _interests[index]['name'],
                          onTap: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: CustomButton(
              onPressed: () {},
              label: 'Save',
            ),
          );
        },
      ),
    );
  }
}
