import 'package:flutter/material.dart';

class RouteAssessment extends StatefulWidget {
  @override
  _AssessmentPageState createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<RouteAssessment> {

  int currentQuestion = 0; // tracks current question

  bool answeredAllQuestions = false;

  TextEditingController _questionController = TextEditingController();

  final List<String> questions = [
    "What is your preferred learning method?",
    "How do you best remember new information?",
    "What type of content do you enjoy most when learning?",
  ];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  
  final Map<int, String> userResponses = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: const Text("Learning Type Assessment")),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: answeredAllQuestions? 

        // ##############
        // All questions answered
        Center(
          child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Great",
              style: TextStyle(
                fontSize: 30.0,
              ),
              ),
          
              SizedBox(height: 20,),
              
              Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_box),
                  Text("Test Completed",
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                  ),
                ],
              ),
          
               SizedBox(height: 20,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_box),
                  Text("Score Assessed",
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                  ),
                ],
              ),  

               SizedBox(height: 40,),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/dataInput');
                } , 
                child: Text("Move on"))
            ],
          ),
        )

        // #############
        // Questions being answered
        : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(questions[currentQuestion],
            style: TextStyle(
              fontSize: 24.0,
            ),
            ),
            
            SizedBox(height: 20,),

            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Your response here...",
              ),
              onTap: () {
                
              },
            ),
            SizedBox(height: 20,),

            ElevatedButton(
              onPressed: () {
                print("User Responses: $userResponses");
                setState(() {
                  currentQuestion = currentQuestion +1;

                  if(currentQuestion >= questions.length) // if all questions answered
                  {
                    answeredAllQuestions = true;
                  }

                });
              },
              child: const Text("Submit Answers"),
            ),
          ],
        ),
      ),
    );
  }
}
