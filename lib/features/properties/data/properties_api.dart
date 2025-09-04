import 'package:dio/dio.dart';

import '../../../config/env.dart';
import '../../../core/services/http_services.dart';
import 'dto/property_dto.dart';

class PropertiesApi {
  final _http = HttpService();

  Future<List<PropertyDto>> getAll() async {
    final Response res = await _http.get('${Env.apiUrl}/api/properties');
    _ensureOk(res);
    final list = (res.data as List).cast<Map<String, dynamic>>();
    return list.map(PropertyDto.fromJson).toList();
  }

  Future<PropertyDto> create(PropertyDto dto) async {
    final body = dto.toJson()..remove('id'); // server gera o id
    final Response res =
    await _http.post('${Env.apiUrl}/api/properties', data: body);
    _ensureOk(res);
    return PropertyDto.fromJson(res.data as Map<String, dynamic>);
  }

  Future<PropertyDto> update(String id, PropertyDto dto) async {
    final Response res = await _http.put(
      '${Env.apiUrl}/api/properties/$id',
      data: dto.toJson(),
    );
    _ensureOk(res);
    return PropertyDto.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> delete(String id) async {
    final Response res = await _http.delete('${Env.apiUrl}/api/properties/$id');
    _ensureOk(res);
  }

  Future<String> uploadCover(String id, String filePath) async {
    final Response res = await _http.postMultipart(
      '${Env.apiUrl}/api/properties/$id/upload-cover',
      fieldName: 'file', // nome do campo no teu controller
      filePath: filePath,
    );
    _ensureOk(res);
    return res.data.toString();
  }

  void _ensureOk(Response r) {
    if (r.statusCode == null || r.statusCode! < 200 || r.statusCode! >= 300) {
      throw Exception('HTTP ${r.statusCode}: ${r.data}');
    }
  }
}
