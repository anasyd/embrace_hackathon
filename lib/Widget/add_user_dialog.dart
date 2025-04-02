// ################################
// Imports.
// ################################

// Base.
import 'package:embrace_hackathon/User-Data/user_handler.dart';
import 'package:flutter/material.dart';

// ################################
// Dialog - Expire Product.
// ################################

class AddUserDialog extends StatefulWidget
{
  // ################################
  // Variables.
  // ################################

  final void Function()?  updateCall;

  // ################################
  // Constructor.
  // ################################
  const AddUserDialog
  (
    {
      required this.updateCall,
      super.key
    }
  );

  @override
  State<StatefulWidget> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog>
{
  // ################################
  // Variables.
  // ################################
  
  // Data.
  final TextEditingController _userNameController = TextEditingController();
  
  // Misc.
  bool isError = false;
  DateTime? pickedDate = DateTime.now();

  // ################################
  // Build Method.
  // ################################
  
  @override
  Widget build(BuildContext context)
  {
    return Dialog
    (
      child: Padding
      (
        padding: EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0, ),
        child: Column
        (
          mainAxisSize: MainAxisSize.min,
          children: 
          [
            // Title.
            (isError)? Text("Please Complete All Details!", style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Theme.of(context).colorScheme.error)) : Text("Add a new user", style: Theme.of(context).textTheme.headlineSmall),

            Padding // Category
            (
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: TextField
              (
                controller: _userNameController,
                decoration: InputDecoration
                (
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  labelText: 'User Name',
                  border: OutlineInputBorder(),
                ),
              )
            ),

            // Buttons.
            Row
            (
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: 
              [
                // Cancel Button
                TextButton
                (
                  child: Text("Cancel"),
                  onPressed: () =>
                  {
                    Navigator.pop(context)
                  }
                ),

                // Submit Button
                TextButton
                (
                  child: Text("Submit"),
                  onPressed: () async
                  {
                    if (_userNameController.text == "")
                    {
                      isError = true;
                      setState(() {});
                    }
                    else
                    {
                      User user =  await UserHandler.instance.createUser
                      (
                        _userNameController.text
                      );
                      
                      UserHandler.instance.currentUser = user;

                      widget.updateCall!();
                      Navigator.pop(context);
                      Navigator.popAndPushNamed(context, "/assess");
                    }
                  }
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}