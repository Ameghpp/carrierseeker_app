part of 'collage_bloc.dart';

@immutable
sealed class CollagesEvent {}

class GetAllCollagesEvent extends CollagesEvent {
  final Map<String, dynamic> params;

  GetAllCollagesEvent({required this.params});
}

class GetRecommendedCollagesEvent extends CollagesEvent {
  final Map<String, dynamic> params;

  GetRecommendedCollagesEvent({required this.params});
}

class GetCollagesByIdEvent extends CollagesEvent {
  final int collageId;

  GetCollagesByIdEvent({required this.collageId});
}
