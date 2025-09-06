import '../../../core/services/http_services.dart';
import 'dto/property_dto.dart';

class PropertiesApi {
  final _http = HttpService();

  Future<List<PropertyDto>> getAll() async {
    final r = await _http.get('/properties');
    if (r.statusCode == 200) {
      return (r.data as List)
          .cast<Map<String, dynamic>>()
          .map(PropertyDto.fromJson)
          .toList();
    }
    throw Exception('HTTP ${r.statusCode}: ${r.data}');
  }

  Future<PropertyDto> create(PropertyDto dto) async {
    final r = await _http.post(
      '/properties',
      data: (dto.toJson()..remove('id')),
    );
    if (r.statusCode == 200 || r.statusCode == 201) {
      return PropertyDto.fromJson(Map<String, dynamic>.from(r.data));
    }
    throw Exception('HTTP ${r.statusCode}: ${r.data}');
  }

  Future<PropertyDto> update(String id, PropertyDto dto) async {
    final r = await _http.put('/properties/$id', data: dto.toJson());
    if (r.statusCode == 200) {
      return PropertyDto.fromJson(Map<String, dynamic>.from(r.data));
    }
    throw Exception('HTTP ${r.statusCode}: ${r.data}');
  }

  Future<void> delete(String id) async {
    final r = await _http.delete('/properties/$id');
    if (r.statusCode == 200 || r.statusCode == 204) return;
    throw Exception('HTTP ${r.statusCode}: ${r.data}');
  }

  Future<String> uploadCover(String id, String filePath) async {
    final r = await _http.postMultipart(
      '/properties/$id/upload-cover',
      fieldName: 'file',
      filePath: filePath,
    );
    if (r.statusCode == 200) return r.data.toString();
    throw Exception('HTTP ${r.statusCode}: ${r.data}');
  }
}
