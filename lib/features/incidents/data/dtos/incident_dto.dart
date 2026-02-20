import 'package:drift/drift.dart';

import '../../../../core/utils/json.dart';
import '../../../../infra/db/app_db.dart';

class IncidentDto {
  final String id;
  final String title;
  final String? description;
  final double? lat;
  final double? lng;
  final String status;
  final DateTime updatedAt;

  const IncidentDto({
    required this.id,
    required this.title,
    required this.updatedAt,
    this.description,
    this.lat,
    this.lng,
    required this.status,
  });

  // ---- DB (Drift row → DTO)
  factory IncidentDto.fromRow(Incident row) {
    return IncidentDto(
      id: row.id,
      title: row.title,
      description: row.description,
      lat: row.lat,
      lng: row.lng,
      status: row.status,
      updatedAt: row.updatedAt,
    );
  }

  // ---- JSON (API → DTO)
  factory IncidentDto.fromJson(Json json) {
    return IncidentDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      status: json['status'] as String? ?? 'open',
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Json toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'lat': lat,
        'lng': lng,
        'status': status,
        'updatedAt': updatedAt.toIso8601String(),
      };

  // ---- DTO → Drift Companion
  IncidentsCompanion toCompanion({bool isDirty = false}) {
    return IncidentsCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      lat: Value(lat),
      lng: Value(lng),
      status: Value(status),
      updatedAt: Value(updatedAt),
      isDirty: Value(isDirty),
    );
  }
}