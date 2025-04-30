import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/user_preferences.dart';

class GeminiService {
  static final _apiKey = dotenv.env['GEMINI_API_KEY'];
  static const _url = 
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=GEMINI_API_KEY';

  static Future<String> getRecommendation(UserPreferences prefs) async {
    final prompt = '''
Sou um assistente de beleza. Com base nas prefências abaixo, recomendarei uma rotina de cuidados com a pele e sugestóes de maquiagem personalizadas:

Tipo de pele: ${prefs.skinTypes.join(', ')}
Alergias: ${prefs.allergies.join(', ')}
Estilo de Maquiagem: ${prefs.makeupStyles.join(', ')}

Dê recomendações claras, práticas e adaptadas à realidade brasileira.
''';

    final response = await http.post(
      Uri.parse('$_url?key=$_apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final text = data['candidates']?[0]['content']?['parts']?[0]?['text'];
      return text ?? 'Não foi possível gerar uma recomendação.';
    } else {
      return 'Erro ao se comunicar com o Gemini: ${response.body}';
    }
  }
}
