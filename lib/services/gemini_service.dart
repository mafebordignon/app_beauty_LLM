import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/user_preferences.dart';

class GeminiService {
  static const _url = 
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  static Future<String> getRecommendation(UserPreferences prefs) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    
    // Verificação para depuração
    if (apiKey == null || apiKey.isEmpty) {
      return 'Erro: Chave API do Gemini não encontrada no arquivo .env';
    }
    
    final prompt = '''
Sou um assistente de beleza. Com base nas prefências abaixo, recomendarei uma rotina de cuidados com a pele e sugestóes de maquiagem personalizadas:

Tipo de pele: ${prefs.skinTypes.join(', ')}
Alergias: ${prefs.allergies.join(', ')}
Estilo de Maquiagem: ${prefs.makeupStyles.join(', ')}

Dê recomendações claras, práticas e adaptadas à realidade brasileira.
''';

    try {
      final response = await http.post(
        Uri.parse('$_url?key=$apiKey'),
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
        return 'Erro ao se comunicar com o Gemini (${response.statusCode}): ${response.body}';
      }
    } catch (e) {
      return 'Exceção ao se comunicar com o Gemini: $e';
    }
  }
}