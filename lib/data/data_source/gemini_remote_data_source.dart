import 'package:google_generative_ai/google_generative_ai.dart';
abstract class GeminiRemoteDataSource {
  Future<String?> getAiResponse(String prompt);
}
class GeminiRemoteDataSourceImpl implements GeminiRemoteDataSource{
  final GenerativeModel _model;

  GeminiRemoteDataSourceImpl(this._model);

  @override
  Future<String?> getAiResponse(String prompt) async {
    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);

    return response.text;
  }
}