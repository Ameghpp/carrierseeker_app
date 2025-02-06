part of 'universities_bloc.dart';

@immutable
sealed class UniversitiesEvent {}

class GetAllUniversitiesEvent extends UniversitiesEvent {
  final Map<String, dynamic> params;

  GetAllUniversitiesEvent({required this.params});
}

class GetRecommendedUniversitiesEvent extends UniversitiesEvent {
  final Map<String, dynamic> params;

  GetRecommendedUniversitiesEvent({required this.params});
}

class GetUniversitiesByIdEvent extends UniversitiesEvent {
  final int universitieId;

  GetUniversitiesByIdEvent({required this.universitieId});
}
