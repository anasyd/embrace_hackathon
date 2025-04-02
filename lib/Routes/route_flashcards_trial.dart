// lib/main.dart
import 'dart:io';
import 'package:embrace_hackathon/models/flashcard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
//import 'package:services/flashcard.dart';
import 'package:embrace_hackathon/services/api_service.dart';


void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcard Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const FlashcardPage(),
    );
  }
}

class FlashcardPage extends StatefulWidget {
  const FlashcardPage({super.key});

  @override
  _FlashcardPageState createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  final ApiService _apiService = ApiService();
  final ImagePicker _picker = ImagePicker();
  dynamic _selectedImage;
  XFile? _webImage;
  List<Flashcard> _flashcards = [];
  bool _isLoading = false;
  String _errorMessage = '';
  int currentCardIndex = 0;
  String? selectedAnswer;

  // Pick image from gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
if (kIsWeb) {
  _webImage = pickedFile;
  _selectedImage = pickedFile; // Keep XFile format for web
} else {
  _selectedImage = pickedFile; // Do not convert to File, use XFile directly
}
        _flashcards = [];
        _errorMessage = '';
      });
    }
  }

  // Generate flashcards from the selected image using the API
  Future<void> _generateFlashcards() async {
    if (_selectedImage == null) {
      setState(() {
        _errorMessage = 'Please select an image first';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final flashcards = await _apiService.getFlashcardsFromImage(
        _selectedImage,
      );
      setState(() {
        _flashcards = flashcards;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
      print('Error: $e');
    }
  }

  // Display current flashcard and handle answer submission
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Flashcards'),
        actions: [
          SegmentControl(),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Select Image'),
              ),
              const SizedBox(height: 16),
              if (_selectedImage != null) ...[
                SizedBox(
                  height: 200,
                  child: kIsWeb
                      ? FutureBuilder<Uint8List>(
                          future: _webImage!.readAsBytes(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done &&
                                snapshot.hasData) {
                              return Image.memory(
                                snapshot.data!,
                                fit: BoxFit.cover,
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        )
                      : kIsWeb
  ? FutureBuilder<Uint8List>(
      future: _webImage!.readAsBytes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return Image.memory(snapshot.data!, fit: BoxFit.cover);
        } else {
          return const CircularProgressIndicator();
        }
      },
    )
  : Image.file(File(_selectedImage.path), fit: BoxFit.cover),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _generateFlashcards,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Generate Flashcards'),
                ),
              ],
              if (_errorMessage.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(_errorMessage, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 16),
              Expanded(
                child: _flashcards.isEmpty
                    ? const Center(
                        child: Text(
                          'No flashcards yet. Upload an image to generate flashcards.',
                        ),
                      )
                    : Column(
                        children: [
                          Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    _flashcards[currentCardIndex].question,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  ...[
                                    _flashcards[currentCardIndex].correctAnswer,
                                    _flashcards[currentCardIndex].wrongAnswer1,
                                    _flashcards[currentCardIndex].wrongAnswer2,
                                    _flashcards[currentCardIndex].wrongAnswer3
                                  ].map((answer) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedAnswer = answer;
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: selectedAnswer == answer
                                              ? Colors.blueAccent
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                        child: Text(
                                          answer,
                                          style: const TextStyle(fontSize: 16),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (selectedAnswer ==
                                          _flashcards[currentCardIndex]
                                              .correctAnswer) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text('Correct!')),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text('Incorrect!')),
                                        );
                                      }
                                      setState(() {
                                        if (currentCardIndex <
                                            _flashcards.length - 1) {
                                          currentCardIndex++;
                                          selectedAnswer = null;
                                        } else {
                                          currentCardIndex = 0;
                                          selectedAnswer = null;
                                        }
                                      });
                                    },
                                    child: const Text('Submit Answer'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SegmentControl extends StatefulWidget {
  @override
  _SegmentControlState createState() => _SegmentControlState();
}

class _SegmentControlState extends State<SegmentControl> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: SegmentedButton<int>(
        segments: const <ButtonSegment<int>>[
          ButtonSegment<int>(value: 0, label: Text('Flash Cards')),
          ButtonSegment<int>(value: 1, label: Text('Audio')),
          ButtonSegment<int>(value: 2, label: Text('List')),
        ],
        selected: {_selectedIndex},
        onSelectionChanged: (Set<int> newSelection) {
          setState(() {
            _selectedIndex = newSelection.first;
          });
        },
      ),
    );
  }
}