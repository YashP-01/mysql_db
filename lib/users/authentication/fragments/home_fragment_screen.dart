import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:mysql_db/users/authentication/fragments/add_user_info.dart';

class HomeFragmentScreen extends StatelessWidget {
  HomeFragmentScreen({super.key});

  // Sample user data. Replace this with your actual user data.
  final List<Map<String, String>> users = [
    {
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'phone': '123-456-7890',
      'address': '123 Main St, City, Country'
    },
    {
      'name': 'Jane Smith',
      'email': 'jane.smith@example.com',
      'phone': '987-654-3210',
      'address': '456 Elm St, City, Country'
    },
    {
      'name': 'Alice Johnson',
      'email': 'alice.johnson@.com',
      'phone': '111-222-3333',
      'address': '789 Pine St, City, Country'
    },
    {
      'name': 'Richard Johnson',
      'email': 'alice.johnson@.com',
      'phone': '111-222-3333',
      'address': '789 Pine St, City, Country'
    },
    {
      'name': 'Stark Paul',
      'email': 'alice.johnson@.com',
      'phone': '111-222-3333',
      'address': '789 Pine St, City, Country'
    },
  ];

  @override
  Widget build(BuildContext context) {
    // To keep track of the currently expanded panel
    List<ExpandableController> controllers = List.generate(users.length, (index) => ExpandableController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Home'),
      ),

      // Main body of home screen
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Master user (John Doe) with other users under it
            ExpandablePanel(
              controller: controllers[0], // John Doe's ExpandableController
              header: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'John Doe', // Displaying John Doe as the header
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'john.doe@example.com', // Displaying John's email
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              collapsed: SizedBox.shrink(),

              expanded: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phone: 123-456-7890',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Address: 123 Main St, City, Country',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 15),


                    // Now we are displaying other users under John Doe
                    Text(
                      'Other Information:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    // List other users under John Doe
                    Column(
                      children: List.generate(users.length - 1, (index) {
                        return ExpandablePanel(
                          controller: controllers[index + 1], // Each user's ExpandableController
                          header: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  users[index + 1]['name'] ?? 'No Name',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  users[index + 1]['email'] ?? 'No Email',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          collapsed: SizedBox.shrink(), // Empty space when collapsed
                          expanded: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Phone: ${users[index + 1]['phone']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Address: ${users[index + 1]['address']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          theme: ExpandableThemeData(
                            iconColor: Colors.black,
                            tapHeaderToExpand: true,
                            tapBodyToExpand: true,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              theme: ExpandableThemeData(
                iconColor: Colors.teal[400],
                tapHeaderToExpand: true,
                tapBodyToExpand: true,
              ),
            ),
          ],
        ),
      ),

      // Floating action button
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal[400],
        onPressed: () {

          /// go to add user info page when clicked
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddUserInfo()));
        },
        label: Text(
          'Add',
          style: TextStyle(color: Colors.grey.shade800),
        ),
        icon: Icon(
          Icons.add,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }
}
