import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

class AddUserInfo extends StatefulWidget {
  const AddUserInfo({super.key});

  @override
  State<AddUserInfo> createState() => _AddUserInfoState();
}

class _AddUserInfoState extends State<AddUserInfo> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool isValidEmail(String email) {
    // Regular expression for validating email
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    EdgeInsetsGeometry padding = screenWidth > 600
        ? EdgeInsets.symmetric(horizontal: 100)
        : EdgeInsets.symmetric(horizontal: 20);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [

              // Main user information form
              SizedBox(height: 6),
              Form(
                key: _formKey,
                child: Column(
                  children: [

                    /// user name
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    /// email
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.grey,
                        ),
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email address';
                        } else if (!isValidEmail(value)) {
                          return 'Invalid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // Expandable section for additional details
              ExpandablePanel(
                header: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Additional Details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),

                collapsed: SizedBox.shrink(),
                expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 6),
                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _addressController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                theme: ExpandableThemeData(
                  iconColor: Colors.teal[400],
                  tapHeaderToExpand: true,
                  tapBodyToExpand: true,
                ),
              ),
              SizedBox(height: 16),

              // Save Button
              ElevatedButton(
                onPressed: () {
                  if(_formKey.currentState!.validate()){
                    // Handle form submission here
                    String name = _nameController.text;
                    String email = _emailController.text;
                    String phone = _phoneController.text;
                    String address = _addressController.text;

                    print("Name: $name, Email: $email, Phone: $phone, Address: $address");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[400],
                  // primary: Colors.teal[400],
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                  minimumSize: Size(screenWidth * 0.7, 53)
                ),
                child: Text(
                  'Save Information',
                  style: TextStyle(color: Colors.grey.shade800),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
