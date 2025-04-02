import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import '../models/flashcard.dart';

class ApiService {
  final String apiUrl =
      // 'https://mango-bush-0a9e12903.5.azurestaticapps.net/api/v1';
      'https://mango-bush-0a9e12903.5.azurestaticapps.net/api/v1/openai/deployments/gpt-4o-mini/chat/completions?api-version=2023-12-01-preview';

  Future<List<Flashcard>> getFlashcardsFromImage(dynamic imageFile) async {
    try {
      final apiKey = dotenv.env['OPEN_AI_API_KEY'] ?? '';
      print('API Key: $apiKey');
      if (apiKey.isEmpty) {
        throw Exception('API key is missing. Please check your .env file.');
      }

      Uint8List imageBytes;

      // Get image bytes based on platform
      if (kIsWeb) {
        if (imageFile is XFile) {
          imageBytes = await imageFile.readAsBytes();
        } else {
          throw Exception('Unsupported file type for web');
        }
      } else {
        if (imageFile is File) {
          imageBytes = await imageFile.readAsBytes();
        } else {
          throw Exception('Unsupported file type for mobile');
        }
      }

      // Convert image to base64
      final base64Image = base64Encode(imageBytes);

      // Prepare the request body in the format expected by Azure OpenAI
      final Map<String, dynamic> requestBody = {
        "messages": [
          {
            "role": "system",
            "content":
                "You are a flashcard creator. Based on the image, create a list of flashcards in JSON format with 'question', 'answer', 'correct_answer', 'wrong_answer_1', 'wrong_answer_2', 'wrong_answer_3' fields.",
          },
          {
            "role": "user",
            "content": [
              {
                "type": "text",
                "text": "Create flashcards based on this image:",
              },
              {
                "type": "image_url",
                "image_url": {"url": "data:image/jpeg;base64,$base64Image"},
              },
            ],
          },
        ],
        "max_tokens": 2000,
        "temperature": 0.7,
      };

      print('Sending request to: $apiUrl');

      // Make the HTTP request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
          'api-key': apiKey, // Some Azure endpoints use this format
        },
        body: json.encode(requestBody),
      );

      print('Response status code: ${response.statusCode}');
      print(
        'Response body: ${response.body.substring(0, min(500, response.body.length))}...',
      ); // Print first 500 chars

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Extract message content based on Azure OpenAI API response format
        final String responseContent =
            jsonResponse['choices'][0]['message']['content'];
        print('Response content: $responseContent');

        // Extract the JSON from the response
        final jsonRegExp = RegExp(r'\[.*\]', dotAll: true);
        final match = jsonRegExp.firstMatch(responseContent);

        if (match != null) {
          final jsonString = match.group(0);
          final List<dynamic> jsonList = json.decode(jsonString!);
          return jsonList.map((json) => Flashcard.fromJson(json)).toList();
        } else {
          // Try to parse the entire response as JSON if no JSON array was found
          try {
            final List<dynamic> jsonList = json.decode(responseContent);
            return jsonList.map((json) => Flashcard.fromJson(json)).toList();
          } catch (e) {
            throw Exception(
              'Failed to parse AI response into flashcards: $responseContent',
            );
          }
        }
      } else {
        throw Exception(
          'API request failed with status code: ${response.statusCode}, message: ${response.body}',
        );
      }
    } catch (e) {
      print('Error creating flashcards: $e');
      throw Exception('Error creating flashcards: $e');
    }
  }

  // Helper function to get minimum of two numbers
  int min(int a, int b) {
    return a < b ? a : b;
  }
}
