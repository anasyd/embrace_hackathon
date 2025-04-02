// ########################
// Imports.
// ########################

// Backend.
import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Routes.
import 'Routes/route_assessment.dart';
import 'Routes/route_data_input.dart';
import 'Routes/route_present_flashcards.dart';
import 'Routes/route_user_select.dart';

// ########################
// Main.
// ########################

Future<void> main() async 
{
  // Ensure flutter is fully initialised.
  WidgetsFlutterBinding.ensureInitialized();
  
  // Setup GPT API.
  await dotenv.load(fileName: ".env");
  OpenAI.apiKey = dotenv.env['apiKey'] ?? '';
  OpenAI.baseUrl = dotenv.env['endpoint'] ?? '';

  // Start the app.
  runApp(const DesktopApp());
}

// ########################
// Material App.
// ########################

class DesktopApp extends StatefulWidget
{
  // ################
  // Constructor.
  // ################

  const DesktopApp
  (
    {
      super.key
    }
  );

  // ################
  // Create State Method.
  // ################

  @override
  State<StatefulWidget> createState() => _DesktopAppState();
}

class _DesktopAppState extends State<DesktopApp>
{
  // ################
  // Build Method.

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp
    (
      // Disable debug banner.
      debugShowCheckedModeBanner: false,
      
      // Setup the different routes.
      routes:
      {
        "/assess"             : (context) => RouteAssessment(),
        "/dataInput"          : (context) => RouteDataInput(),
        "/present_flashcards" : (context) => RoutePresentFlashcards(),
        "/userselect"         : (context) => RouteUserSelect(),
      },

      // Set the intial route.
      initialRoute: "/present_flashcards",
    );
  }
}