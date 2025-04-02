// ########################
// Imports.
// ########################

// Backend.
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Routes.
import 'Routes/route_assessment.dart';
import 'Routes/route_data_input.dart';
import 'Routes/route_present_flashcards.dart';
import 'Routes/route_user_select.dart';
// import 'Routes/route_upload_flashcards.dart';
import 'Routes/route_test_flashcards.dart'; // new import

// ########################
// Main.
// ########################

void main() async {
  // Ensure flutter is fully initialised.
  WidgetsFlutterBinding.ensureInitialized();

  // Setup GPT API.
  await dotenv.load(fileName: ".env");
  // Start the app.
  runApp(const DesktopApp());
}

// ########################
// Material App.
// ########################

class DesktopApp extends StatefulWidget {
  // ################
  // Constructor.
  // ################

  const DesktopApp({super.key});

  // ################
  // Create State Method.
  // ################

  @override
  State<StatefulWidget> createState() => _DesktopAppState();
}

class _DesktopAppState extends State<DesktopApp> {
  // ################
  // Build Method.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Disable debug banner.
      debugShowCheckedModeBanner: false,

      // Setup the different routes.
      routes: {
        "/assess": (context) => RouteAssessment(),
        "/dataInput": (context) => RouteDataInput(),
        "/present_flashcards": (context) => RoutePresentFlashcards(),
        "/userselect": (context) => RouteUserSelect(),
        // "/upload_flashcards": (context) => const RouteUploadFlashcards(),
        "/test_flashcards":
            (context) => const RouteTestFlashcards(), // new route
      },

      // Set the intial route.
      initialRoute: "/test_flashcards", // set test screen as initial route
    );
  }
}

// // lib/main.dart
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:image_picker/image_picker.dart';
// import 'dart:typed_data';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'models/flashcard.dart';
// import 'services/api_service.dart';

// void main() async {
//   // Ensure Flutter binding is initialized
//   WidgetsFlutterBinding.ensureInitialized();

//   // Load environment variables
//   await dotenv.load(fileName: ".env");

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flashcard Generator',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: const HomePage(),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final ApiService _apiService = ApiService();
//   final ImagePicker _picker = ImagePicker();
//   dynamic _selectedImage;
//   XFile? _webImage;
//   List<Flashcard> _flashcards = [];
//   bool _isLoading = false;
//   String _errorMessage = '';

//   Future<void> _pickImage() async {
//     final XFile? pickedFile = await _picker.pickImage(
//       source: ImageSource.gallery,
//     );

//     if (pickedFile != null) {
//       setState(() {
//         if (kIsWeb) {
//           _webImage = pickedFile;
//           _selectedImage = pickedFile; // Store XFile for web
//         } else {
//           _selectedImage = File(pickedFile.path); // Store File for mobile
//         }
//         _flashcards = [];
//         _errorMessage = '';
//       });
//     }
//   }

//   Future<void> _generateFlashcards() async {
//     if (_selectedImage == null) {
//       setState(() {
//         _errorMessage = 'Please select an image first';
//       });
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _errorMessage = '';
//     });

//     try {
//       final flashcards = await _apiService.getFlashcardsFromImage(
//         _selectedImage,
//       );
//       setState(() {
//         _flashcards = flashcards;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error: ${e.toString()}';
//         _isLoading = false;
//       });
//       print('Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Flashcard Generator')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             ElevatedButton(
//               onPressed: _pickImage,
//               child: const Text('Select Image'),
//             ),
//             const SizedBox(height: 16),
//             if (_selectedImage != null) ...[
//               SizedBox(
//                 height: 200,
//                 child:
//                     kIsWeb
//                         ? FutureBuilder<Uint8List>(
//                           future: _webImage!.readAsBytes(),
//                           builder: (context, snapshot) {
//                             if (snapshot.connectionState ==
//                                     ConnectionState.done &&
//                                 snapshot.hasData) {
//                               return Image.memory(
//                                 snapshot.data!,
//                                 fit: BoxFit.cover,
//                               );
//                             } else {
//                               return const Center(
//                                 child: CircularProgressIndicator(),
//                               );
//                             }
//                           },
//                         )
//                         : Image.file(_selectedImage, fit: BoxFit.cover),
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: _isLoading ? null : _generateFlashcards,
//                 child:
//                     _isLoading
//                         ? const CircularProgressIndicator()
//                         : const Text('Generate Flashcards'),
//               ),
//             ],
//             if (_errorMessage.isNotEmpty) ...[
//               const SizedBox(height: 16),
//               Text(_errorMessage, style: const TextStyle(color: Colors.red)),
//             ],
//             const SizedBox(height: 16),
//             Expanded(
//               child:
//                   _flashcards.isEmpty
//                       ? const Center(
//                         child: Text(
//                           'No flashcards yet. Upload an image to generate flashcards.',
//                         ),
//                       )
//                       : ListView.builder(
//                         itemCount: _flashcards.length,
//                         itemBuilder: (context, index) {
//                           final flashcard = _flashcards[index];
//                           return Card(
//                             margin: const EdgeInsets.only(bottom: 16),
//                             child: Padding(
//                               padding: const EdgeInsets.all(16.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Question: ${flashcard.question}',
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Text('Answer: ${flashcard.answer}'),
//                                   const SizedBox(height: 8),
//                                   Text(
//                                     'Correct Answer: ${flashcard.correctAnswer}',
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Text(
//                                     'Wrong Answer: ${flashcard.wrongAnswer1}',
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
