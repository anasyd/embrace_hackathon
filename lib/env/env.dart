// lib/env/env.dart
import 'package:envied/envied.dart';
part '.env';

@Envied(path: ".env")
abstract class Env {
  @EnviedField(varName: 'OPEN_AI_API_KEY') // the .env variable.
  static apiKey = _Env.apiKey;
}
