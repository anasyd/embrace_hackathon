import 'package:embrace_hackathon/User-Data/user_handler.dart';
import 'package:embrace_hackathon/Widget/add_user_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class RouteUserSelect extends StatefulWidget {
  const RouteUserSelect({super.key});

  @override
  State<StatefulWidget> createState() => _RouteUserSelectState();
}

class _RouteUserSelectState extends State<RouteUserSelect>
{

  bool _isLoading = false;
  List<User> userList = [];

  @override
  void initState() {
    super.initState();

    _loadData(); 
  }

  void _loadData() async
  {
    setState(() => _isLoading = true);

    userList = await UserHandler.instance.getUserList();

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF), // Light gray background
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center( // Center everything in the middle of the screen
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Shrink to fit content
                  crossAxisAlignment: CrossAxisAlignment.center, // Center align content
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 16.0), // Reduce padding
                      child: Text(
                        'Hello!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28, // Slightly smaller font size
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    SizedBox
                    (
                      width: 500, // Limit the width of the GridView
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // Keep 3 cards in a row
                          crossAxisSpacing: 8, // Reduce spacing
                          mainAxisSpacing: 8, // Reduce spacing
                        ),
                        padding: const EdgeInsets.all(8),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(), // Disable scrolling
                        itemCount: userList.length + 1, // Extra item for the add button
                        itemBuilder: (context, index) {
                          if (index < userList.length) {
                            return _userCard(
                              name: userList[index].userName, 
                              color: Colors.amber, 
                              context: context
                            );
                          } else {
                            return _addUserCard(context); // Last item is the add button
                          }
                        },
                      ),
                    )

                    /*
                    // USER PROFILE CARDS
                    SizedBox(
                      width: 500, // Limit the width of the GridView
                      child: GridView.count(
                        crossAxisCount: 3, // Keep 3 cards in a row
                        padding: const EdgeInsets.all(8),
                        crossAxisSpacing: 8, // Reduce spacing
                        mainAxisSpacing: 8, // Reduce spacing
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(), // Disable scrolling
                        children: [
                          _userCard(name: "Max", color: Colors.amber, context: context),
                          _userCard(name: "Lucy", color: Colors.orangeAccent, context: context),
                          _addUserCard(context),
                        ],
                      ),
                    ),*/
                  ],
                ),
              ),
            ),

            // BLUE BAR AT THE BOTTOM
            Container(
              height: 100, // Height of the blue bar
              color: const Color.fromARGB(255, 5, 46, 80), // Blue color
            ),
          ],
        ),
      ),
    );
  }

  // USER CARD WIDGET
  Widget _userCard({required String name, required Color color, required BuildContext context}) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected user: $name')),
        );

        Navigator.pushNamed(context, '/assess');
      },
      child: Card(
        color: color, // Add background color
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 16, // Smaller avatar size
              backgroundColor: Colors.black,
              child: Icon(Icons.person, color: Colors.white, size: 16), // Smaller icon
            ),
            const SizedBox(height: 4), // Reduce spacing
            Text(
              name,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500), // Slightly smaller text
            ),
          ],
        ),
      ),
    );
  }

  // ADD USER CARD WIDGET
  Widget _addUserCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(context: context, builder: (BuildContext context) 
        {
          return AddUserDialog
          (
            updateCall: _loadData
          );
        });
      },
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Center(
          child: Icon(Icons.add, size: 24, color: Colors.grey), // Smaller icon
        ),
      ),
    );
  }
}