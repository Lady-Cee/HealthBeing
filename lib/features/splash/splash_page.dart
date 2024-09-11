import 'package:flutter/material.dart';

import '../login/pages/login_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/health3.png"),
                    fit: BoxFit.cover,
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.only(left:12.0, right: 12, top: 100, bottom: 100),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/healthLogo.png", width: MediaQuery.sizeOf(context).width * 0.8),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    Text("Your personalised guide to better health, offering tailored tips, diets, and exercises to help you manage your wellness effortlessly",
                      style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.black54), textAlign: TextAlign.center,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    Text("Empowering You to Live Healthier, Every Day!",
                      style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade400,
                          foregroundColor: Colors.white,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Get Started ✌️", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                            Icon(Icons.arrow_forward)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
          ),
        )
    );
  }
}
