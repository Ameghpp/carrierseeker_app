import 'dart:io';

import 'package:carrier_seeker_app/common_widgets.dart/custom_image_picker_button.dart';
import 'package:carrier_seeker_app/common_widgets.dart/custom_text_formfield.dart';
import 'package:carrier_seeker_app/features/profile/profile_bloc/profile_bloc.dart';
import 'package:carrier_seeker_app/util/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../common_widgets.dart/custom_alert_dialog.dart';
import '../../common_widgets.dart/custom_button.dart';
import '../../common_widgets.dart/custom_dropdownmenu.dart';
import '../../util/value_validator.dart';

class EditProfile extends StatefulWidget {
  final Map profileDetails;
  const EditProfile({super.key, required this.profileDetails});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _percentageController = TextEditingController();
  final TextEditingController _streamController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ProfileBloc _profileBloc = ProfileBloc();
  File? file;
  List _streams = [];
  int? _selectedStream;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500), () {
      requestStoragePermission();
    });
    getStreams();
    _nameController.text = widget.profileDetails['name'];
    _percentageController.text = widget.profileDetails['overall_percentage'];
    if (widget.profileDetails['streams'] != null) {
      _streamController.text = widget.profileDetails['streams']?['name'];
      _selectedStream = widget.profileDetails['streams']?['id'];
    }

    super.initState();
  }

  void getStreams() {
    _profileBloc.add(GetStreamsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EDIT PROFILE',
          style: TextStyle(
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
      body: BlocProvider.value(
        value: _profileBloc,
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileFailureState) {
              showDialog(
                context: context,
                builder: (context) => CustomAlertDialog(
                  title: 'Failure',
                  description: state.message,
                  primaryButton: 'Try Again',
                  onPrimaryPressed: () {
                    getStreams();
                    Navigator.pop(context);
                  },
                ),
              );
            } else if (state is GetStreamSuccessState) {
              _streams = state.streams;
              Logger().w(_streams);
              setState(() {});
            } else if (state is ProfileSuccessState) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  CustomImagePickerButton(
                    selectedImage: widget.profileDetails['photo_url'],
                    height: 150,
                    width: 150,
                    borderRadius: 100,
                    onPick: (pick) {
                      file = pick;
                      setState(() {});
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextFormField(
                    isLoading: state is ProfileLoadingState,
                    labelText: 'Name',
                    controller: _nameController,
                    validator: alphabeticWithSpaceValidator,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextFormField(
                    isLoading: state is ProfileLoadingState,
                    labelText: "Overall Percentage +1,+2",
                    controller: _percentageController,
                    validator: percentageValidator,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomDropDownMenu(
                    isLoading: state is ProfileLoadingState,
                    initialSelection: _selectedStream,
                    controller: _streamController,
                    hintText: "Select Streams",
                    onSelected: (selected) {
                      _selectedStream = selected;
                      Logger().w(_selectedStream);
                    },
                    dropdownMenuEntries: List.generate(
                      _streams.length,
                      (index) => DropdownMenuEntry(
                        value: _streams[index]['id'],
                        label: _streams[index]['name'],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomButton(
                    isLoading: state is ProfileLoadingState,
                    inverse: true,
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          _selectedStream != null) {
                        Map<String, dynamic> details = {
                          'name': _nameController.text.trim(),
                          'overall_percentage':
                              _percentageController.text.trim(),
                          'stream_id': _selectedStream,
                        };

                        if (file != null) {
                          details['photo_file'] = file!;
                          details['photo_name'] = file!.path;
                        }
                        BlocProvider.of<ProfileBloc>(context).add(
                          EditProfileEvent(
                            profile: details,
                            profileId: widget.profileDetails['id'],
                          ),
                        );
                      }
                    },
                    label: 'Save',
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
