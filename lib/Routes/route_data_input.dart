// ########################
// Imports.
// ########################
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';


// ########################
// Data Input Screen
// ########################
class RouteDataInput extends StatefulWidget {
  RouteDataInput({super.key});

  @override
  _UploadPdfScreenState createState() => _UploadPdfScreenState();
}


class _UploadPdfScreenState extends State<RouteDataInput> {

  // File Name
  String? fileName; 

  // Allows user to pick a file 
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // must be PDF
    );

    if (result != null) {
      setState(() {
        fileName = result.files.single.name; // save file as file name
      });
    }
  }

  // ##############
  // Build Method.

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(

      appBar: AppBar(title: const Text("Upload PDF")),
      body: 
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // Upload Button
            ElevatedButton(
              onPressed: pickFile,
              child: const Text("Upload PDF"),
            ),

            // Filename (if inputted)
            if (fileName != null) ...[
              const SizedBox(height: 20),
              Text("Selected File: $fileName", style: const TextStyle(fontSize: 16)),
            ],
          ],
        ),
      ),
    );
  }
}

