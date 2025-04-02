import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  OpenAI.apiKey = dotenv.env['apiKey'] ?? '';
  OpenAI.baseUrl = dotenv.env['endpoint'] ?? '';
  runApp(const MyApp());
}
