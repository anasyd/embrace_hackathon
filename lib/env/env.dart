// lib/env/env.dart
import 'package:envied/envied.dart';
part '.env';

@Envied(path: ".env")
abstract class Env {
  @EnviedField(varName: 'OPEN_AI_API_KEY') // the .env variable.
  static const apiKey = _Env.apiKey;

  @EnviedField(varName: 'OPEN_AI_ENDPOINT') // the .env variable.
  static const endpoint = _Env.endpoint;
}
