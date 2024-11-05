import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.asset("images/bg.jpg", fit: BoxFit.cover
              )
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 120),
                    height: 50,
                    width: MediaQuery.of(context).size.width/2.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),color: Colors.black
                    ),
                      child: Center(child: Text('Start', style: TextStyle(color: Color.fromARGB(
                          255, 243, 226, 184), fontSize: 30, fontWeight: FontWeight.bold)))
                  ),
                ),
              ],
            ),
            
          ],
        ),
      ),
    );
  }
}