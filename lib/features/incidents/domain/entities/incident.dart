import 'package:equatable/equatable.dart';

class Incident extends Equatable {
  final String id;
  final String title;
  final String? description;
  final double? lat;
  final double? lng;
  final String status;
  final DateTime updatedAt;

  const Incident({
    required this.id,
    required this.title,
    required this.updatedAt,
    this.description,
    this.lat,
    this.lng,
    this.status = 'open',
  });

  bool get isOpen => status == 'open';
  bool get isResolved => status == 'resolved';

  Incident copyWith({
    String? title,
    String? description,
    double? lat,
    double? lng,
    String? status,
    DateTime? updatedAt,
  }) {
    return Incident(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        lat,
        lng,
        status,
        updatedAt,
      ];
}