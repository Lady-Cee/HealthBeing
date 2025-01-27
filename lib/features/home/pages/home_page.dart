import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../global/toast_error.dart';
import '../../geminiresult/health_guide.dart';
import '../../login/pages/login_page.dart';
import '../widgets/home_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userName;
  bool _isLoading = false;
  String? _rawResponse;
  Map<String, dynamic>? _healthGuideData;

  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _bloodPressureController = TextEditingController();
  final TextEditingController _sugarLevelController = TextEditingController();
  final TextEditingController _cholesterolController = TextEditingController();
  final picker = ImagePicker();

  final List<String> _healthConditions = [
    "Diabetes",
    "Hypertension",
    "Asthma",
    "Ulcer",
    "Hemorrhoids (piles)",
    "Cholesterol",
    "Arthritis",
    "Heart Disease",
    "Kidney Disease",
    "Anemia",
    "Thyroid Disorder"
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userData =
        await FirebaseFirestore.instance.collection("users").doc(user.uid).get();

        setState(() {
          String fullName = userData.get("name") ?? "User";
          userName = fullName.split(' ').first;
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  void _validateAndGenerateHealthGuide() {
    if (_ageController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _bloodPressureController.text.isEmpty ||
        _sugarLevelController.text.isEmpty ||
        _cholesterolController.text.isEmpty) {
      showToast(message: "Please fill in all details");
      return;
    }
    _generateHealthGuide();
  }

  Future<void> _generateHealthGuide() async {
    setState(() {
      _isLoading = true;
      _healthGuideData = null;
      _rawResponse = null;
    });

    try {
      final gemini = Gemini.instance;
      final response = await gemini.text(
        "Generate a structured health guide for someone with the following details: "
            "Age: ${_ageController.text}, Weight: ${_weightController.text}, "
            "Blood Pressure: ${_bloodPressureController.text}, Sugar Level: ${_sugarLevelController.text}, "
            "Cholesterol: ${_cholesterolController.text}, Health Condition(s): ${_healthConditions.join(', ')}. "
            "Include specialized exercises, nutrition tips, health quotes, mindfulness exercises, and health tips. "
            "Format the response as a JSON object with these keys: specializedExercise, nutritionTips, healthQuote, "
            "meditation, healthTips.",
      );

      if (response?.output != null) {
        setState(() {
          _rawResponse = response!.output;
          _healthGuideData = _parseHealthGuide(response.output!);
        });
      } else {
        throw Exception('No output from Gemini');
      }
    } catch (e) {
      print('Error generating health guide: $e');
      setState(() {
        _rawResponse = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Map<String, dynamic> _parseHealthGuide(String response) {
    try {
      final cleanedResponse = response
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();
      return jsonDecode(cleanedResponse);
    } catch (e) {
      print('Error parsing JSON: $e');
      return {'error': 'Invalid JSON format'};
    }
  }

  Widget _buildHealthGuideDisplay() {
    if (_healthGuideData != null && _healthGuideData!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Personalized Health Guide',
            // style: Theme.of(context).textTheme.headline6.copyWith(
            //   fontWeight: FontWeight.bold,
            //   color: Theme.of(context).primaryColor,
            // ),
          ),
          ..._healthGuideData!.entries.map((entry) => _buildSection(entry.key, entry.value)),
        ],
      );
    } else if (_rawResponse != null) {
      return Text(
        'Raw Response: $_rawResponse',
        style: TextStyle(color: Colors.red),
      );
    } else {
      return const Text('No health guide generated yet.');
    }
  }

  Widget _buildSection(String title, dynamic content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            content is List
                ? Column(
              children: content.map<Widget>((item) => Text("- $item")).toList(),
            )
                : Text(content.toString()),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Provider.of<HomeProvider>(context, listen: false).setUserImage(File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Live Healthy, ${userName ?? 'User'}"),
        backgroundColor: Colors.green.shade100,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: homeProvider.userImage != null
                    ? FileImage(homeProvider.userImage!)
                    : const AssetImage("assets/images/placeholder.png") as ImageProvider,
                child: homeProvider.userImage == null
                    ? Icon(Icons.camera_alt, size: 30, color: Colors.grey.shade700)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            _buildHealthGuideDisplay(),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: "Age"),
            ),
            TextField(
              controller: _weightController,
              decoration: const InputDecoration(labelText: "Weight"),
            ),
            TextField(
              controller: _bloodPressureController,
              decoration: const InputDecoration(labelText: "Blood Pressure"),
            ),
            TextField(
              controller: _sugarLevelController,
              decoration: const InputDecoration(labelText: "Sugar Level"),
            ),
            TextField(
              controller: _cholesterolController,
              decoration: const InputDecoration(labelText: "Cholesterol"),
            ),
            ElevatedButton(
              onPressed: _validateAndGenerateHealthGuide,
              child: _isLoading ? const CircularProgressIndicator() : const Text("Generate Guide"),
            ),
          ],
        ),
      ),
    );
  }
}



// import 'dart:convert';
// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gemini/flutter_gemini.dart';
// import 'package:provider/provider.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../../../global/toast_error.dart';
// import '../../geminiresult/health_guide.dart';
// import '../../login/pages/login_page.dart';
// import '../widgets/home_provider.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   String? userName;
//
//   String? _selectedAge;
//   String? _selectedWeight;
//   String? _selectedBloodPressure;
//   String? _selectedSugarLevel;
//   String? _selectedCholesterol;
//   String? _selectedHealthCondition;
//   bool _isLoading = false;
//   String? _rawResponse;
//   Map<String, dynamic>? _healthGuideData;
//
//   final TextEditingController _ageController = TextEditingController();
//   final TextEditingController _weightController = TextEditingController();
//   final TextEditingController _bloodPressureController = TextEditingController();
//   final TextEditingController _sugarLevelController = TextEditingController();
//   final TextEditingController _cholesterolController = TextEditingController();
//
//   final picker = ImagePicker();
//
//
//   final List<String> _healthConditions = [
//     "Diabetes", "Hypertension", "Asthma", "Ulcer", "Hemorrhoids (piles)",
//     "Cholesterol", "Arthritis", "Heart Disease", "Kidney Disease",
//     "Anemia", "Thyroid Disorder"
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _getUserData();
//   }
//
//   Future<void> _getUserData() async {
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         DocumentSnapshot userData = await FirebaseFirestore.instance
//             .collection("users")
//             .doc(user.uid)
//             .get();
//
//         setState(() {
//           String fullName = userData.get("name") ?? "User";
//           userName = fullName.split(' ').first;
//         });
//       }
//     } catch (e) {
//       print('Error fetching user data: $e');
//     }
//   }
//
//   void updateInputValues() {
//     _selectedAge = _ageController.text.trim().isNotEmpty ? _ageController.text.trim() : null;
//     _selectedWeight = _weightController.text.trim().isNotEmpty ? _weightController.text.trim() : null;
//     _selectedBloodPressure = _bloodPressureController.text.trim().isNotEmpty ? _bloodPressureController.text.trim() : null;
//     _selectedSugarLevel = _sugarLevelController.text.trim().isNotEmpty ? _sugarLevelController.text.trim() : null;
//     _selectedCholesterol = _cholesterolController.text.trim().isNotEmpty ? _cholesterolController.text.trim() : null;
//   }
//
//   void validateFields() {
//     if (_ageController.text.isEmpty || _weightController.text.isEmpty ||
//         _bloodPressureController.text.isEmpty || _sugarLevelController.text.isEmpty ||
//         _cholesterolController.text.isEmpty) {
//       showToast(message: "Please fill in all details");
//     } else {
//       updateInputValues();
//       _generateHealthGuide();
//     }
//   }
//
//   Future<void> _generateHealthGuide() async {
//     setState(() {
//       _isLoading = true;
//       _healthGuideData = null;
//       _rawResponse = null;
//     });
//
//     final gemini = Gemini.instance;
//     try {
//       final response = await gemini.text(
//           "Generate a structured health guide for someone with the age of $_selectedAge, weight $_selectedWeight, "
//               "blood pressure level $_selectedBloodPressure, sugar level $_selectedSugarLevel, "
//               "cholesterol level $_selectedCholesterol, and health condition(s): $_selectedHealthCondition. "
//               "The guide should include: 1. Specialized exercises 2. Nutrition tips 3. Health quote 4. Mindfulness "
//               "and Meditation 5. Health tips and Education. "
//                "Format the response as a JSON object with these keys: "
//               "specializedExercise, nutritionTips, healthQuote, meditation, healthTips."
//               "For exercises and tips, use an array of strings. "
//               " Example format:"
//              "{"
//              " \"specializedExercise\" : [\"Exercise 1\", \"Exercise 2\"],"
//              " \"nutritionTips\" : [\"Tip 1\", \"Tip 2\"],"
//              " \"healthQuote\" : [\"Quote 1\", \"Quote 2\"],"
//              " \"meditation\" : [\"Exercise 1\", \"Exercise 2\"],"
//              " \"healthTips\" : [\"Tip 1\", \"Tip 2\"],"
//             "}" );
//
//       if (response?.output != null) {
//         print("Raw Gemini response:");
//         print(response!.output);
//         setState(() {
//           _rawResponse = response.output;
//           _healthGuideData = _parseHealthGuideData(response.output!);
//           _isLoading = false;
//         });
//       } else {
//         throw Exception('No output from Gemini');
//       }
//     } catch (e) {
//       print('Error generating workout plan: $e');
//       setState(() {
//         _isLoading = false;
//         _healthGuideData = null;
//         _rawResponse = 'Error: $e';
//       });
//     }
//   }
//
//   Map<String, dynamic> _parseHealthGuideData(String text) {
//     // Remove any markdown formatting
//     text = text.replaceAll('```json', '').replaceAll('```', '').trim();
//     try {
//       // Replace problematic number ranges with strings
//       text = text.replaceAllMapped(
//           RegExp(r':\s*(\d+)-(\d+)([^\d]|$)'),
//               (match) => ': "${match.group(1)}-${match.group(2)}"${match.group(3)}');
//       // Parse the JSON
//       Map<String, dynamic> jsonResponse = jsonDecode(text);
//       return _processJsonResponse(jsonResponse);
//     } catch (e) {
//       print('Error parsing JSON: $e');
//       // If JSON parsing fails, fall back to text parsing
//       return _parseHealthGuideDataText(text);
//     }
//   }
//
//   Map<String, dynamic> _processJsonResponse(Map<String, dynamic> jsonResponse) {
//     // Process each section of the workout plan
//     ['specializedExercise', 'nutritionTips', 'healthQuote', 'meditation ','healthTips'].forEach((key) {
//       if (jsonResponse[key] is List) {
//         jsonResponse[key] = jsonResponse[key].map((item) {
//           if (item is Map) {
//             return item.entries.map((e) => "${e.key}: ${e.value}").join(', ');
//           }
//           return item.toString();
//         }).toList();
//       }
//     });
//     return jsonResponse;
//   }
//
//   Map<String, dynamic> _parseHealthGuideDataText(String text) {
//     final Map<String, dynamic> plan = {};
//     String currentSection = '';
//     List<String> currentList = [];
//
//     for (var line in text.split('\n')) {
//       line = line.trim();
//       if (line.isEmpty) continue;
//
//       if (line.endsWith(':')) {
//         if (currentSection.isNotEmpty) {
//           plan[currentSection] =
//           currentList.isNotEmpty ? currentList : 'No details provided';
//           currentList = [];
//         }
//         currentSection = line.substring(0, line.length - 1);
//       } else {
//         if (line.startsWith('•') || line.startsWith('-')) {
//           currentList.add(line.substring(1).trim());
//         } else {
//           currentList.add(line);
//         }
//       }
//     }
//
//     if (currentSection.isNotEmpty) {
//       plan[currentSection] =
//       currentList.isNotEmpty ? currentList : 'No details provided';
//     }
//
//     return plan;
//   }
//
//   Widget _generateHealthGuideDisplay() {
//     if (_healthGuideData != null && _healthGuideData!.isNotEmpty) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Your Personalized Health Guide',
//             style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//               fontWeight: FontWeight.bold,
//               color: Theme.of(context).primaryColor,
//             ),
//           ),
//           const SizedBox(height: 16),
//           ..._healthGuideData!.entries.map((entry) => _buildSection(entry.key, entry.value)),
//         ],
//       );
//     } else  if (_rawResponse != null) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Raw Response (Debug Info):',
//             style: Theme.of(context).textTheme.titleMedium?.copyWith(
//               fontWeight: FontWeight.bold,
//               color: Colors.red,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(_rawResponse!),
//         ],
//       );
//     } else {
//       return const Text('No workout plan generated yet.');
//     }
//   }
//
//   Widget _buildSection(String title, dynamic content) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             if (content is List)
//               ...content.map((item) => Padding(
//                 padding: const EdgeInsets.only(bottom: 4),
//                 child: Text(item.toString()),
//               ))
//             else
//               Text(content.toString()),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _pickImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       Provider.of<HomeProvider>(context, listen: false).setUserImage(File(pickedFile.path));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final homeProvider = Provider.of<HomeProvider>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Live Healthy, $userName 😊", style: TextStyle(color: Colors.green)),
//         backgroundColor: Colors.green.shade100,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           color: Colors.green.shade100,
//           image: DecorationImage(
//             image: AssetImage("assets/images/health3.png"),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 GestureDetector(
//                   onTap: _pickImage,
//                   child: CircleAvatar(
//                     radius: 50,
//                     backgroundImage: homeProvider.userImage != null
//                         ? FileImage(homeProvider.userImage!)
//                         : const AssetImage("assets/images/health3.png") as ImageProvider,
//                     child: homeProvider.userImage == null
//                         ? Icon(Icons.camera_alt, size: 30, color: Colors.grey.shade700)
//                         : null,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 _generateHealthGuideDisplay(),
//                 RichText(
//                     textAlign: TextAlign.center,
//                     text: TextSpan(
//                         children: [
//                           TextSpan(
//                             text: "Hello, ",
//                             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
//                           ),
//
//                           TextSpan(
//                             text: "$userName! ",
//                             style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.green),
//                           ),
//
//                           TextSpan(
//                             text: "It's great to see you! ",
//                             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
//                           ),
//                           TextSpan(
//                             text: "\n", // Adds space between sections
//                           ),
//                           TextSpan(
//                             text: "\n", // Adds space between sections
//                           ),
//                           TextSpan(
//                             text: "Your health is your greatest asset ",
//                             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
//                           ),
//                           TextSpan(
//                             text: "\n", // Adds space between sections
//                           ),
//                           TextSpan(
//                             text: "Let's make today count for your well-being. ",
//                             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
//                           ),
//                           TextSpan(
//                             text: "\n", // Adds space between sections
//                           ),
//                           TextSpan(
//                             text: "Keep moving toward a healthier 👌, happier you!! 😊 ",
//                             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
//                           ),
//                         ]
//                     )
//                 ),
//                 SizedBox(height: MediaQuery.of(context).size.height * 0.03),
//
//                 TextField(
//                   controller: _ageController,
//                   keyboardType: TextInputType.phone,
//                   decoration: InputDecoration(
//                     labelText: "Age",
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 SizedBox(height: MediaQuery.of(context).size.height * 0.03),
//
//                 TextField(
//                   controller: _weightController,
//                   keyboardType: TextInputType.phone,
//                   decoration: InputDecoration(
//                     labelText: "Weight (kg)",
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 SizedBox(height: MediaQuery.of(context).size.height * 0.03),
//
//                 TextField(
//                   controller: _bloodPressureController,
//                   keyboardType: TextInputType.phone,
//                   decoration: InputDecoration(
//                     labelText: "Blood Pressure Level (mmHg)",
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 SizedBox(height: MediaQuery.of(context).size.height * 0.03),
//
//                 TextField(
//                   controller: _sugarLevelController,
//                   keyboardType: TextInputType.phone,
//                   decoration: InputDecoration(
//                     labelText: "Sugar Level (mg/dl)",
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 SizedBox(height: MediaQuery.of(context).size.height * 0.03),
//
//                 TextField(
//                   controller: _cholesterolController,
//                   keyboardType: TextInputType.phone,
//                   decoration: InputDecoration(
//                     labelText: "Cholesterol Level (mg/dl)",
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 SizedBox(height: MediaQuery.of(context).size.height * 0.03),
//
//                 //health conditions dropdown
//                 DropdownButtonFormField<String>(
//                   value: homeProvider.selectedHealthCondition,
//                   hint: Text("Select Health Condition"),
//                   items: _healthConditions.map((condition) {
//                     return DropdownMenuItem(
//                       value: condition,
//                       child: Text(condition,
//                         style: TextStyle(color: Colors.green, fontSize: 18),
//                         // overflow: TextOverflow.visible,
//                       ),
//                     );
//                   }).toList(),
//                   onChanged: (String? newValue) {
//                     if (newValue != null) {
//                       homeProvider.setHealthCondition(newValue);
//                     }
//                   },
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                   ),
//                   dropdownColor: Colors.green.shade100,
//                 ),
//
//
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: validateFields,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green.shade400,
//                     foregroundColor: Colors.white,
//                   ),
//                   child: _isLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                   : const Text("Get Your Health Guide", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                 ),
//       //           const SizedBox(height: 24),
//       //         if (_generateHealthGuide != null || _rawResponse != null)
//       //       Expanded(
//       //       child: SingleChildScrollView(
//       //       child: _generateHealthGuideDisplay()
//       //       ),
//       // ),
//                 // ElevatedButton(
//                 //   onPressed: validateFields,
//                 //   style: ElevatedButton.styleFrom(
//                 //     backgroundColor: Colors.green.shade400,
//                 //     foregroundColor: Colors.white,
//                 //   ),
//                 //   child: Text("Get Your Health Guide", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//






// import 'dart:convert';
// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gemini/flutter_gemini.dart';
// import 'package:health_being_tips/features/home/widgets/home_provider.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
//
// import '../../../global/toast_error.dart';
// import '../../geminiresult/health_guide.dart';
// import '../../login/pages/login_page.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   String? userName;
//
//   @override
//   void initState() {
//     super.initState();
//     _getUserData();
//   }
//
//   Future<void> _getUserData() async {
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         DocumentSnapshot userData = await FirebaseFirestore.instance
//             .collection("users")
//             .doc(user.uid)
//             .get();
//
//         setState(() {
//           // Split the name and take the first part
//          String fullName = userData.get("name") ?? "User";
//           userName = fullName.split(' ').first; // get  the first name
//         });
//       }
//     } catch (e) {
//       print('Error fetching user data: $e');
//     }
//     }
//   final TextEditingController _ageController = TextEditingController();
//   final TextEditingController _weightController = TextEditingController();
//   final TextEditingController _bloodPressureController = TextEditingController();
//   final TextEditingController _sugarLevelController = TextEditingController();
//   final TextEditingController _cholesterolController = TextEditingController();
//
//   final picker = ImagePicker();
//
//   final List<String> _healthConditions = [
//     "Diabetes", "Hypertension", "Asthma", "Ulcer", " Hemorrhoids (piles)", "Cholesterol", "Arthritis", "Heart Disease", "Kidney Disease", "Anemia", "Thyroid Disorder"
//   ];
//
//   void ValidateFields(){
//     final age = _ageController.text.trim();
//     final weight = _weightController.text.trim();
//     final bp = _bloodPressureController.text.trim();
//     final sugar = _sugarLevelController.text.trim();
//     final cholesterol = _cholesterolController.text.trim();
//
//     if (age.isEmpty || weight.isEmpty || bp.isEmpty || sugar.isEmpty
//         || cholesterol.isEmpty) {
//       showToast(message: "Please fill in all details");
//     } else {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const HealthGuidePage()),
//       );
//     }
// }
//   @override
//   Widget build(BuildContext context) {
//     final homeProvider = Provider.of<HomeProvider>(context);
//     return WillPopScope(
//       onWillPop: () async {
//         // Navigate to the login page when back button is pressed
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => LoginPage()),
//         );
//         return false;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("Live Healthy, $userName 😊", style: TextStyle(color: Colors.green),),
//           backgroundColor: Colors.green.shade100,
//         ),
//          body: Container(
//            decoration: BoxDecoration(
//                color: Colors.green.shade100,
//                // image: DecorationImage(
//                //   image: AssetImage("assets/images/health3.png"),
//                //   fit: BoxFit.cover,
//                // )
//            ),
//            child: Padding(
//              padding: const EdgeInsets.all(16),
//              child: SingleChildScrollView(
//                child: Column(
//                  children: [
//
//
//                    //pictures upload
//                    GestureDetector(
//                      onTap: _pickImage,
//                      child: CircleAvatar(
//                        radius: 50,
//                        backgroundImage: homeProvider.userImage != null
//                        ? FileImage(homeProvider.userImage!)
//                            : const AssetImage("assets/images/health3.png"),
//                        child: homeProvider.userImage == null
//                          ? Icon(Icons.camera_alt, size: 30, color: Colors.grey.shade700,)
//                            : null,
//                      ),
//                    ),
//                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//
//                    RichText(
//                        textAlign: TextAlign.center,
//                        text: TextSpan(
//                       children: [
//                          TextSpan(
//                            text: "Hello, ",
//                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
//                          ),
//
//                          TextSpan(
//                            text: "$userName! ",
//                            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.green),
//                          ),
//
//                          TextSpan(
//                            text: "It's great to see you! ",
//                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
//                          ),
//                         TextSpan(
//                           text: "\n", // Adds space between sections
//                         ),
//                         TextSpan(
//                           text: "\n", // Adds space between sections
//                         ),
//                          TextSpan(
//                            text: "Your health is your greatest asset ",
//                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
//                          ),
//                         TextSpan(
//                           text: "\n", // Adds space between sections
//                         ),
//                          TextSpan(
//                            text: "Let's make today count for your well-being. ",
//                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
//                          ),
//                         TextSpan(
//                           text: "\n", // Adds space between sections
//                         ),
//                          TextSpan(
//                            text: "Keep moving toward a healthier 👌, happier you!! 😊 ",
//                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
//                          ),
//                        ]
//                      )
//                    ),
//                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
//
//                    TextField(
//                      controller: _ageController,
//                      keyboardType: TextInputType.number,
//                      decoration: InputDecoration(
//                        labelText: "Age",
//                        border: OutlineInputBorder(),
//                      ),
//                    ),
//                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
//
//                    TextField(
//                      controller: _weightController,
//                      keyboardType: TextInputType.number,
//                      decoration: InputDecoration(
//                        labelText: "Weight (kg)",
//                        border: OutlineInputBorder(),
//                      ),
//                    ),
//                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
//
//                    TextField(
//                      controller: _bloodPressureController,
//                      keyboardType: TextInputType.number,
//                      decoration: InputDecoration(
//                        labelText: "Blood Pressure Level (mmHg)",
//                        border: OutlineInputBorder(),
//                      ),
//                    ),
//                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
//
//                    TextField(
//                      controller: _sugarLevelController,
//                      keyboardType: TextInputType.number,
//                      decoration: InputDecoration(
//                        labelText: "Sugar Level (mg/dl)",
//                        border: OutlineInputBorder(),
//                      ),
//                    ),
//                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
//
//                    TextField(
//                      controller: _cholesterolController,
//                      keyboardType: TextInputType.number,
//                      decoration: InputDecoration(
//                        labelText: "Cholesterol Level (mg/dl)",
//                        border: OutlineInputBorder(),
//                      ),
//                    ),
//                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
//
//                 //health conditions dropdown
//                    DropdownButtonFormField<String>(
//                      value: homeProvider.selectedHealthCondition,
//                        hint: Text("Select Health Condition"),
//                        items: _healthConditions.map((condition) {
//                          return DropdownMenuItem(
//                            value: condition,
//                              child: Text(condition,
//                              style: TextStyle(color: Colors.green, fontSize: 18),
//                             // overflow: TextOverflow.visible,
//                              ),
//                          );
//                        }).toList(),
//                        onChanged: (newValue) {
//                        homeProvider.setHealthCondition(newValue!);
//                        },
//                      decoration: const InputDecoration(
//                        border: OutlineInputBorder(),
//                      ),
//                      dropdownColor: Colors.green.shade100,
//                    ),
//
//                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
//
//                    ElevatedButton(
//                      onPressed: ValidateFields,
//                      style: ElevatedButton.styleFrom(
//                        backgroundColor: Colors.green.shade400,
//                        foregroundColor: Colors.white,
//                      ),
//                      child: Text("Get Your Health Guide", style: TextStyle(
//                          fontSize: 20,
//                          fontWeight: FontWeight.bold),),),
//                    Expanded(
//                        child: SingleChildScrollView(
//                          child: _generateHealthGuideDisplay(),
//                        ),
//                    ),
//
//                    //save profile button
//                    // ElevatedButton(
//                    //     onPressed: _saveDetails,
//                    //     child: Text("Save Details"),
//                    // )
//
//                  ],
//                )
//              ),
//            ),
//          )
//       ),
//     );
//   }
//
//   // function to pick image from gallery
// Future<void> _pickImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//
//     if (pickedFile != null) {
//       Provider.of<HomeProvider>(context, listen: false)
//           .setUserImage(File(pickedFile.path));
//     }
// }
//
//   void _saveDetails() {
//     // Logic to save profile details, including health condition selection and profile picture
//     print('Profile Saved with picture and other details');
//   }
//
//
//   Widget _generateHealthGuideDisplay() {
//     if (_healthConditions != null) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Your Personalized Health Guide',
//             style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//               fontWeight: FontWeight.bold,
//               color: Theme.of(context).primaryColor,
//             ),
//           ),
//           const SizedBox(height: 16),
//           ..._healthConditions!.entries
//               .map((entry) => _buildSection(entry.key, entry.value)),
//         ],
//       );
//     }  else {
//       return const Text('No Health Guide generated yet.');
//     }
//   }
//
//   Widget _buildSection(String title, dynamic content) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             if (content is List)
//               ...content.map((item) => Padding(
//                 padding: const EdgeInsets.only(bottom: 4),
//                 child: Text(item.toString()),
//               ))
//             else
//               Text(content.toString()),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _generateHealthGuide() async {
//     final gemini = Gemini.instance;
//     try {
//       final response = await gemini.text(
//         "Generate a structured health guide for someone with the age"
//             "of $_ageController, $_weightController, $_bloodPressureController,"
//             "$_sugarLevelController, $_cholesterolController and $_healthConditions."""
//             "The guide should include: 1. Specialized exercises 2. Nutrition tips 3. Health quote"
//             "4. Mindfulness and Meditation 5. Health tips and Education."
//             "Format the response as a JSON object with these keys: specializedExercise, nutritionTips,"
//             "healthQuote, meditation, healthTips."
//             "Example format:"
//             "{"
//             " \"specializedExercise\" : [\"Exercise 1\", \"Exercise 2\"],"
//             " \"nutritionTips\" : [\"Tip 1\", \"Tip 2\"],"
//             " \"healthQuote\" : [\"Quote 1\", \"Quote 2\"],"
//             " \"meditation\" : [\"Exercise 1\", \"Exercise 2\"],"
//             " \"healthTips\" : [\"Tip 1\", \"Tip 2\"],"
//             "}" );
//     } catch (e) {
//       print('Error generating health guide: $e');
//     }
//   }
//   Map<String, dynamic> _parseHealthGuide(String text) {
//     // Remove any markdown formatting
//     text = text.replaceAll('```json', '').replaceAll('```', '').trim();
//
//     try {
//       // Replace problematic number ranges with strings
//       text = text.replaceAllMapped(
//           RegExp(r':\s*(\d+)-(\d+)([^\d]|$)'),
//               (match) =>
//           ': "${match.group(1)}-${match.group(2)}"${match.group(3)}');
//
//       // Parse the JSON
//       Map<String, dynamic> jsonResponse = jsonDecode(text);
//       return _processJsonResponse(jsonResponse);
//     } catch (e) {
//       print('Error parsing JSON: $e');
//       // If JSON parsing fails, fall back to text parsing
//       return _parseHealthGuideText(text);
//     }
//   }
//
//   Map<String, dynamic> _processJsonResponse(Map<String, dynamic> jsonResponse) {
//     // Process each section of the workout plan
//     ['specializedExercise', 'nutritionTips', 'healthQuote', 'meditation ','healthTips'].forEach((key) {
//       if (jsonResponse[key] is List) {
//         jsonResponse[key] = jsonResponse[key].map((item) {
//           if (item is Map) {
//             return item.entries.map((e) => "${e.key}: ${e.value}").join(', ');
//           }
//           return item.toString();
//         }).toList();
//       }
//     });
//     return jsonResponse;
//   }
//
//   Map<String, dynamic> _parseHealthGuideText(String text) {
//     final Map<String, dynamic> plan = {};
//     String currentSection = '';
//     List<String> currentList = [];
//
//     for (var line in text.split('\n')) {
//       line = line.trim();
//       if (line.isEmpty) continue;
//
//       if (line.endsWith(':')) {
//         if (currentSection.isNotEmpty) {
//           plan[currentSection] =
//           currentList.isNotEmpty ? currentList : 'No details provided';
//           currentList = [];
//         }
//         currentSection = line.substring(0, line.length - 1);
//       } else {
//         if (line.startsWith('•') || line.startsWith('-')) {
//           currentList.add(line.substring(1).trim());
//         } else {
//           currentList.add(line);
//         }
//       }
//     }
//
//     if (currentSection.isNotEmpty) {
//       plan[currentSection] =
//       currentList.isNotEmpty ? currentList : 'No details provided';
//     }
//
//     return plan;
//   }
// }
//
// extension on List<String> {
//   get entries => null;
// }
