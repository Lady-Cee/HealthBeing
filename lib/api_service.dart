//
// import 'package:google_generative_ai/google_generative_ai.dart';
//
// void fetchAIResponse() async {
//   final apiKey = "AIzaSyAYaPwhuDkxkwWaN6oX29cuiK6t4hGmknM";
//
//   final client = GenerativeAIClient(apiKey: apiKey);
//
//   try {
//     final result = await client.generateText(
//       prompt: 'Tell me about healthy eating habits',
//     );
//     print(result);
//   } catch (e) {
//     print("Error: $e");
//   }
// }
//
// //
// // // import 'dart:convert';
// // // import  'package:http/http.dart';
// // //
// // // class ApiService {
// // //   final String apiKey = "AIzaSyAYaPwhuDkxkwWaN6oX29cuiK6t4hGmknM";
// // //   final String apiUrl = "http://gemini.google.com/";
// // //
// // //   Future<List<dynamic>> fetchHealthTips() async {
// // //     final response = await http.get(
// // //       Uri.parse(apiUrl),
// // //       headers: {
// // //         "Authorization": "Bearer $apiKey",
// // //         "Content-Type": "application/json",
// // //       },
// // //     );
// // //
// // //     if (response.statusCode == 200) {
// // //       return jsonDecode(response.body);
// // //     } else {
// // //       throw Exception("Failed to load health tips");
// // //     }
// // //   }
// // // }