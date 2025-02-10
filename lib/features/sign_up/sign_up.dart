import 'package:carrier_seeker_app/common_widgets.dart/custom_button.dart';
import 'package:carrier_seeker_app/common_widgets.dart/custom_text_formfield.dart';
import 'package:carrier_seeker_app/features/interest/add_intersts.dart';
import 'package:carrier_seeker_app/features/login/signin_screen.dart';
import 'package:carrier_seeker_app/features/sign_up/sign_up_bloc/sign_up_bloc.dart';
import 'package:carrier_seeker_app/util/value_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../common_widgets.dart/custom_alert_dialog.dart';
import '../../common_widgets.dart/custom_dropdownmenu.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _percentageController = TextEditingController();
  final TextEditingController _streamController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final SignUpBloc _signUpBloc = SignUpBloc();

  bool _obscureText = true;
  List _streams = [];
  int? _selectedStream;

  @override
  void initState() {
    getStreams();
    super.initState();
  }

  void getStreams() {
    _signUpBloc.add(GetStreamsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 139, 196, 247),
        body: BlocProvider.value(
          value: _signUpBloc,
          child: BlocConsumer<SignUpBloc, SignUpState>(
            listener: (context, state) {
              if (state is SignUpFailureState) {
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
              } else if (state is SignUpSuccessState) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AddInterests()),
                  (route) => false,
                );
              }
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Image.asset('assets/login_image.png'),
                      const Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomTextFormField(
                        isLoading: state is SignUpLoadingState,
                        labelText: 'Name',
                        controller: _nameController,
                        validator: alphabeticWithSpaceValidator,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomTextFormField(
                        isLoading: state is SignUpLoadingState,
                        labelText: 'Email',
                        controller: _emailController,
                        validator: emailValidator,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        obscureText: _obscureText,
                        controller: _passwordController,
                        validator: passwordValidator,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          hintText: 'password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              _obscureText = !_obscureText;
                              setState(() {});
                            },
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _confirmPasswordController,
                        validator: (value) {
                          confirmPasswordValidator(
                              value, _passwordController.text);
                          return null;
                        },
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          hintText: 'confirm password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              _obscureText = !_obscureText;
                              setState(() {});
                            },
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomTextFormField(
                        isLoading: state is SignUpLoadingState,
                        labelText: "Overall Percentage +1,+2",
                        controller: _percentageController,
                        validator: percentageValidator,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomDropDownMenu(
                        isLoading: state is SignUpLoadingState,
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
                        isLoading: state is SignUpLoadingState,
                        inverse: true,
                        onPressed: () {
                          if (_formKey.currentState!.validate() &&
                              _selectedStream != null) {
                            BlocProvider.of<SignUpBloc>(context).add(
                              SignUpUserEvent(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                  userDetails: {
                                    'name': _nameController.text.trim(),
                                    'overall_percentage':
                                        _percentageController.text.trim(),
                                    'stream_id': _selectedStream,
                                  }),
                            );
                          }
                        },
                        label: 'Sign Up',
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Dont have an account?',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(0),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SigninScreen()));
                            },
                            child: const Text('Sign Up'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
