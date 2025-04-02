import 'package:flutter/material.dart';



class RoutePresentFlashcards extends StatefulWidget {
  @override
  _FlashcardPageState createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<RoutePresentFlashcards> {
  final List<Map<String, dynamic>> flashcards = [
    {
      'question': 'What is the capital of France?',
      'answers': ['Paris', 'London', 'Berlin', 'Madrid'],
      'correctAnswer': 'Paris'
    },
    {
      'question': 'What is 2 + 2?',
      'answers': ['3', '4', '5', '6'],
      'correctAnswer': '4'
    },
  ];

  int currentCardIndex = 0;
  String? selectedAnswer;
  final Set<String> selectedAnswers = Set();

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
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    flashcards[currentCardIndex]['question'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ...flashcards[currentCardIndex]['answers']
                      .map((answer) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedAnswer = answer;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: selectedAnswer == answer
                              ? Colors.blueAccent
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
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
                      if (selectedAnswer == flashcards[currentCardIndex]['correctAnswer']) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Correct!')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Incorrect!')),
                        );
                      }
                      setState(() {
                        if (currentCardIndex < flashcards.length - 1) {
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