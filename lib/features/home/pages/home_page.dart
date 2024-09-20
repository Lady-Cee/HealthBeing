import 'dart:io';

import 'package:flutter/material.dart';
import 'package:health_being_tips/features/home/widgets/home_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../login/pages/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _bloodPressureController = TextEditingController();
  final TextEditingController _sugarLevelController = TextEditingController();
  final TextEditingController _cholesterolController = TextEditingController();

  final picker = ImagePicker();

  final List<String> _healthConditions = [
    "Diabetes", "Hypertension", "Asthma", "Ulcer","Cholesterol", "Arthritis", "Heart Disease", "Kidney Disease", "Anemia", "Thyroid Disorder"
  ];

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        // Navigate to the login page when back button is pressed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
        return false;
      },
      child: Scaffold(
         body: Container(
           decoration: BoxDecoration(
               color: Colors.green.shade100,
               // image: DecorationImage(
               //   image: AssetImage("assets/images/health3.png"),
               //   fit: BoxFit.cover,
               // )
           ),
           child: Padding(
             padding: const EdgeInsets.only(left: 16, right: 16, top: 100, bottom: 16),
             child: SingleChildScrollView(
               child: Column(
                 children: [


                   //pictures upload
                   GestureDetector(
                     onTap: _pickImage,
                     child: CircleAvatar(
                       radius: 50,
                       backgroundImage: homeProvider.userImage != null
                       ? FileImage(homeProvider.userImage!)
                           : const AssetImage("assets/images/health3.png"),
                       child: homeProvider.userImage == null
                         ? Icon(Icons.camera_alt, size: 30, color: Colors.grey.shade700,)
                           : null,
                     ),
                   ),
                   SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                   Align(
                     alignment: Alignment.centerLeft,
                     child: Text(
                       "Hello ${homeProvider.userName}, It's great to see you! Your health is your greatest asset. Let's "
                           "make today count for your well-being and keep moving toward a healthier 👌, happier you!! 😊 ",
                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green.shade700),
                     ),
                   ),
                   SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                   TextField(
                     controller: _ageController,
                     keyboardType: TextInputType.number,
                     decoration: InputDecoration(
                       labelText: "Age",
                       border: OutlineInputBorder(),
                     ),
                   ),
                   SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                   TextField(
                     controller: _weightController,
                     keyboardType: TextInputType.number,
                     decoration: InputDecoration(
                       labelText: "Weight (kg)",
                       border: OutlineInputBorder(),
                     ),
                   ),
                   SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                   TextField(
                     controller: _bloodPressureController,
                     keyboardType: TextInputType.number,
                     decoration: InputDecoration(
                       labelText: "Blood Pressure Level (mmHg)",
                       border: OutlineInputBorder(),
                     ),
                   ),
                   SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                   TextField(
                     controller: _sugarLevelController,
                     keyboardType: TextInputType.number,
                     decoration: InputDecoration(
                       labelText: "Sugar Level (mg/dl)",
                       border: OutlineInputBorder(),
                     ),
                   ),
                   SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                   TextField(
                     controller: _cholesterolController,
                     keyboardType: TextInputType.number,
                     decoration: InputDecoration(
                       labelText: "Cholesterol Level (mg/dl)",
                       border: OutlineInputBorder(),
                     ),
                   ),
                   SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                //health conditions dropdown
                   DropdownButtonFormField<String>(
                     value: homeProvider.selectedHealthCondition,
                       hint: Text("Select Health Condition"),
                       items: _healthConditions.map((condition) {
                         return DropdownMenuItem(
                           value: condition,
                             child: Text(condition),
                         );
                       }).toList(),
                       onChanged: (newValue) {
                       homeProvider.setHealthCondition(newValue!);
                       },
                     decoration: const InputDecoration(
                       border: OutlineInputBorder(),
                     ),
                   ),

                   SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                   //save profile button
                   ElevatedButton(
                       onPressed: _saveDetails,
                       child: Text("Save Details"),
                   )

                 ],
               )
             ),
           ),
         )
      ),
    );
  }

  // function to pick image from gallery
Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      Provider.of<HomeProvider>(context, listen: false)
          .setUserImage(File(pickedFile.path));
    }
}

  void _saveDetails() {
    // Logic to save profile details, including health condition selection and profile picture
    print('Profile Saved with picture and other details');
  }
}
