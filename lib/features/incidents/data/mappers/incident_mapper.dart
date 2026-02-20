import '../../domain/entities/incident.dart';
import '../dtos/incident_dto.dart';

class IncidentMapper {
  static Incident toEntity(IncidentDto dto) {
    return Incident(
      id: dto.id,
      title: dto.title,
      description: dto.description,
      lat: dto.lat,
      lng: dto.lng,
      status: dto.status,
      updatedAt: dto.updatedAt,
    );
  }

  static IncidentDto toDto(Incident entity) {
    return IncidentDto(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      lat: entity.lat,
      lng: entity.lng,
      status: entity.status,
      updatedAt: entity.updatedAt,
    );
  }
}