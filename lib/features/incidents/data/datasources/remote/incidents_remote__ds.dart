import 'package:dio/dio.dart';
import '../../../../../core/utils/json.dart';
import '../../dtos/incident_dto.dart';

class IncidentsRemoteDataSource {
  final Dio dio;

  // mock API base (trocaremos depois)
  static const String baseUrl = 'https://example.com/api/incidents';

  IncidentsRemoteDataSource(this.dio);

  Future<List<IncidentDto>> fetchAll() async {
    final response = await dio.get(baseUrl);

    final list = (response.data as List)
        .map((json) => IncidentDto.fromJson(json as Json))
        .toList();

    return list;
  }

  Future<void> create(Json payload) async {
    await dio.post(baseUrl, data: payload);
  }

  Future<void> update(Json payload) async {
    await dio.put('$baseUrl/${payload['id']}', data: payload);
  }

  Future<void> delete(String id) async {
    await dio.delete('$baseUrl/$id');
  }

  Future<void> applyOutboxOperation(String operation, Json payload) async {
    switch (operation) {
      case 'create':
        return create(payload);
      case 'update':
        return update(payload);
      case 'delete':
        return delete(payload['id']);
      default:
        throw Exception('Unknown operation: $operation');
    }
  }

  Future<List<IncidentDto>> pullLatest() async {
    return fetchAll();
  }
}