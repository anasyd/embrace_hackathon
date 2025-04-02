import 'package:flutter/material.dart';

class RouteUserSelect extends StatelessWidget {
  const RouteUserSelect({super.key});

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
                    ),
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Add new user")),
        );
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