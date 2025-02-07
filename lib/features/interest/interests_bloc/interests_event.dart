part of 'interests_bloc.dart';

@immutable
sealed class InterestsEvent {}

class GetAllInterestsEvent extends InterestsEvent {
  final Map<String, dynamic> params;

  GetAllInterestsEvent({required this.params});
}

class GetAllUserInterestsEvent extends InterestsEvent {
  final Map<String, dynamic> params;

  GetAllUserInterestsEvent({required this.params});
}

class AddInterestsEvent extends InterestsEvent {
  final List<Map<String, dynamic>> interestDetails;

  AddInterestsEvent({required this.interestDetails});
}

class EditInterestsEvent extends InterestsEvent {
  final List<Map<String, dynamic>> interestDetails;

  EditInterestsEvent({
    required this.interestDetails,
  });
}

class DeleteInterestsEvent extends InterestsEvent {
  final int interestId;

  DeleteInterestsEvent({required this.interestId});
}
