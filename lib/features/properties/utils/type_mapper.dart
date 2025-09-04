class TypeMapper {
  static const Map<String, String> _ptToApi = {
    'Apartamento': 'Apartment',
    'Moradia': 'House',
    'Quarto': 'Room',
    'Estúdio': 'Studio',
  };

  static const Map<String, String> _apiToPt = {
    'Apartment': 'Apartamento',
    'House': 'Moradia',
    'Room': 'Quarto',
    'Studio': 'Estúdio',
  };

  static String toApi(String? pt) {
    final key = (pt ?? '').trim();
    if (key.isEmpty) return '';
    return _ptToApi[key] ?? key;
  }

  static String toPt(String? api) {
    final key = (api ?? '').trim();
    if (key.isEmpty) return '';
    return _apiToPt[key] ?? key;
  }
}
