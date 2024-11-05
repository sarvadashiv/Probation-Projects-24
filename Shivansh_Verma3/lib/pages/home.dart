import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../service.dart';
 class Home extends StatefulWidget {
   const Home({super.key});
 
   @override
   State<Home> createState() => _HomeState();
 }
 
 class _HomeState extends State<Home> {
   bool Music= true, Geography= false, FoodDrink= false, ScienceNature= false,Entertainment= false, answernow=false;
   String? question, answer;
   List<String> option=[];

   @override
   void initState(){
     super.initState();
     fetchQuiz('music');
     RestOption();
   }

   Future<void> fetchQuiz(String category) async{
     final response = await http.get(Uri.parse('https://api.api-ninjas.com/v1/trivia?category=$category'),
     headers:{
       "Content-Type": "application/json",
       "X-Api-Key": APIKEY
     }
     );
     if(response.statusCode==200){
       List<dynamic> jsonData= jsonDecode(response.body);
       if(jsonData.isNotEmpty){
         Map<String , dynamic> quiz = jsonData[0];
         question= quiz['question'];
         answer= quiz['answer'];
       }
       setState(() {});
     }
   }
   Future<void> RestOption() async{
     final response = await http.get(Uri.parse('https://api.api-ninjas.com/v1/randomword'),
         headers:{
           "Content-Type": "application/json",
           "X-Api-Key": APIKEY
         }
     );
     if(response.statusCode==200){
       Map<String, dynamic> jsonData= jsonDecode(response.body);
       if(jsonData.isNotEmpty){
         String word= jsonData["word"].toString();

         option.add(word);
       }
       if(option.length<3){
         RestOption();
       }
       else{
         option.add(answer!);
         shuffleList();
       }
       setState(() {});
     }
   }
   void shuffleList(){
     option= List.from(option)..shuffle(Random());
     setState(() {

     });
 }
   Future<void> refreshQuiz() async {
     answernow = false;
     option.clear();
     await fetchQuiz(Music ? 'music' : Geography ? 'geography' : FoodDrink ? 'fooddrink' : ScienceNature ? 'sciencenature' : 'entertainment');
     await RestOption();
   }
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       body: Container(
           child: Stack(
             children: [
               Container(
                   height: MediaQuery.of(context).size.height,
                   width: MediaQuery.of(context).size.width,
                   child: Image.asset("images/bg1.jpg", fit: BoxFit.cover
                   )
               ),
               Container(
                 margin: EdgeInsets.only(top: 50.0, left: 10, right: 10),
                 child: Column(
                   children: [
                     Container(
                       height: 50,
                       child: ListView(
                         scrollDirection: Axis.horizontal,
                         children: [
                           Music?Container(
                             margin: EdgeInsets.only(right: 20),
                             child: Material(
                               elevation:5.0,
                               borderRadius: BorderRadius.circular(30),
                               child: Container(
                                 width: 120,
                                 decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(30)),
                                 child: Center(
                                   child: Text(
                                     'Music',
                                     style: TextStyle(
                                         color: Colors.white,
                                         fontSize: 24,
                                         fontWeight: FontWeight.bold
                                     ),),
                                 ),
                               ),
                             ),
                           ): GestureDetector(
                             onTap: ()async{
                               Music= true;
                               Geography= false;
                               FoodDrink= false;
                               ScienceNature= false;
                               Entertainment=false;
                               answernow=false;
                               option=[];
                               await RestOption();
                               await fetchQuiz('music');
                               setState(() {

                               });
                             },
                             child: Container(
                               width: 120,
                               margin: EdgeInsets.only( right: 20),
                               decoration: BoxDecoration(color: Colors.white54, borderRadius: BorderRadius.circular(30)),
                               child: Center(
                                 child: Text(
                                     'Music',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold
                                      ),),
                               ),
                             ),
                           ),
                           Geography?Container(
                             margin: EdgeInsets.only(right: 20),
                             child: Material(
                               elevation:5.0,
                               borderRadius: BorderRadius.circular(30),
                               child: Container(
                                 width: 170,
                                 decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(30)),
                                 child: Center(
                                   child: Text(
                                     'Geography',
                                     style: TextStyle(
                                         color: Colors.white,
                                         fontSize: 24,
                                         fontWeight: FontWeight.bold
                                     ),),
                                 ),
                               ),
                             ),
                           ): GestureDetector(
                             onTap: ()async{
                               Music= false;
                               Geography= true;
                               FoodDrink= false;
                               ScienceNature= false;
                               Entertainment=false;
                               answernow=false;
                               option=[];
                               await RestOption();
                               await fetchQuiz('geography');
                               setState(() {

                               });
                             },
                             child: Container(
                               width: 170,
                               margin: EdgeInsets.only( right: 20),
                               decoration: BoxDecoration(color: Colors.white54, borderRadius: BorderRadius.circular(30)),
                               child: Center(
                                 child: Text(
                                   'Geography',
                                   style: TextStyle(
                                       color: Colors.black,
                                       fontSize: 24,
                                       fontWeight: FontWeight.bold
                                   ),),
                               ),
                             ),
                           ),
                           FoodDrink?Container(
                             margin: EdgeInsets.only(right: 20),
                             child: Material(
                               elevation:5.0,
                               borderRadius: BorderRadius.circular(30),
                               child: Container(
                                 width: 180,
                                 decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(30)),
                                 child: Center(
                                   child: Text(
                                     'FoodDrink',
                                     style: TextStyle(
                                         color: Colors.white,
                                         fontSize: 24,
                                         fontWeight: FontWeight.bold
                                     ),),
                                 ),
                               ),
                             ),
                           ): GestureDetector(
                             onTap: ()async{
                               Music= false;
                               Geography= false;
                               FoodDrink= true;
                               ScienceNature= false;
                               Entertainment=false;
                               answernow=false;
                               option=[];
                               await RestOption();
                               await fetchQuiz('fooddrink');
                               setState(() {

                               });
                             },
                             child: Container(
                               width: 180,
                               margin: EdgeInsets.only( right: 20),
                               decoration: BoxDecoration(color: Colors.white54, borderRadius: BorderRadius.circular(30)),
                               child: Center(
                                 child: Text(
                                   'FoodDrink',
                                   style: TextStyle(
                                       color: Colors.black,
                                       fontSize: 24,
                                       fontWeight: FontWeight.bold
                                   ),),
                               ),
                             ),
                           ),
                           ScienceNature?Container(
                             margin: EdgeInsets.only(right: 20),
                             child: Material(
                               elevation:5.0,
                               borderRadius: BorderRadius.circular(30),
                               child: Container(
                                 width: 210,
                                 decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(30)),
                                 child: Center(
                                   child: Text(
                                     'ScienceNature',
                                     style: TextStyle(
                                         color: Colors.white,
                                         fontSize: 24,
                                         fontWeight: FontWeight.bold
                                     ),),
                                 ),
                               ),
                             ),
                           ): GestureDetector(
                             onTap: ()async{
                               Music= false;
                               Geography= false;
                               FoodDrink= false;
                               ScienceNature= true;
                               Entertainment=false;
                               answernow=false;
                               option=[];

                               await RestOption();
                               await fetchQuiz('sciencenature');
                               setState(() {

                               });
                             },
                             child: Container(
                               width: 210,
                               margin: EdgeInsets.only( right: 20),
                               decoration: BoxDecoration(color: Colors.white54, borderRadius: BorderRadius.circular(30)),
                               child: Center(
                                 child: Text(
                                   'ScienceNature',
                                   style: TextStyle(
                                       color: Colors.black,
                                       fontSize: 24,
                                       fontWeight: FontWeight.bold
                                   ),),
                               ),
                             ),
                           ),
                           Entertainment?Container(
                             margin: EdgeInsets.only(right: 20),
                             child: Material(
                               elevation:5.0,
                               borderRadius: BorderRadius.circular(30),
                               child: Container(
                                 width: 210,
                                 decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(30)),
                                 child: Center(
                                   child: Text(
                                     'Entertainment',
                                     style: TextStyle(
                                         color: Colors.white,
                                         fontSize: 24,
                                         fontWeight: FontWeight.bold
                                     ),),
                                 ),
                               ),
                             ),
                           ): GestureDetector(
                             onTap: ()async{
                               Music= false;
                               Geography= false;
                               FoodDrink= false;
                               ScienceNature= false;
                               Entertainment= true;
                               answernow=false;
                               option=[];
                               await RestOption();
                               await fetchQuiz('entertainment');
                               setState(() {

                               });
                             },
                             child: Container(
                               width: 210,
                               margin: EdgeInsets.only( right: 20),
                               decoration: BoxDecoration(color: Colors.white54, borderRadius: BorderRadius.circular(30)),
                               child: Center(
                                 child: Text(
                                   'Entertainment',
                                   style: TextStyle(
                                       color: Colors.black,
                                       fontSize: 24,
                                       fontWeight: FontWeight.bold
                                   ),),
                               ),
                             ),
                           ),
                         ],
                       ),
                     ),
                     SizedBox(height: 40,),
                     option.length!=4? Center(child: CircularProgressIndicator()): Container(
                       width: MediaQuery.of(context).size.width,
                       margin: EdgeInsets.only(right: 10, left: 10),
                       decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
                       child: Column(children: [
                         SizedBox(height: 40),
                         Container(
                           width: MediaQuery.of(context).size.width/1.3,
                           child: Text(
                             question!,
                             textAlign: TextAlign.center,
                             style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 24,
                                 fontWeight: FontWeight.bold
                             ),),
                         ),
                         SizedBox(height: 40,),
                         GestureDetector(
                           onTap: (){
                             answernow=true;
                             setState(() {

                             });
                           },
                           child: Container(
                             padding: EdgeInsets.all(12),
                             margin: EdgeInsets.only(right: 20, left: 20),
                             width: MediaQuery.of(context).size.width,
                             decoration: BoxDecoration(border: Border.all(
                                 color:answernow?answer==option[0].replaceAll(RegExp(r'[\[\]]'), '')? Colors.green: Colors.red: Colors.white38, width: 2), borderRadius: BorderRadius.circular(30)),
                             child: Center(
                               child: Text(option[0].replaceAll(RegExp(r'[\[\]]'), ''),
                                 textAlign: TextAlign.center,
                                 style: TextStyle(
                                     color: Colors.white,
                                     fontSize: 24,
                                     fontWeight: FontWeight.w500
                                 ),),
                             ),
                           ),
                         ),
                         SizedBox(height: 20,),
                         GestureDetector(
                           onTap: (){
                             answernow=true;
                             setState(() {

                             });
                           },
                           child: Container(
                             padding: EdgeInsets.all(12),
                             margin: EdgeInsets.only(right: 20, left: 20),
                             width: MediaQuery.of(context).size.width,
                             decoration: BoxDecoration(border: Border.all(color:answernow?answer==option[1].replaceAll(RegExp(r'[\[\]]'), '')? Colors.green: Colors.red: Colors.white38, width: 2), borderRadius: BorderRadius.circular(30)),
                             child: Center(
                               child: Text(
                                 option[1].replaceAll(RegExp(r'[\[\]]'), ''),
                                 textAlign: TextAlign.center,

                                 style: TextStyle(
                                     color: Colors.white,
                                     fontSize: 24,
                                     fontWeight: FontWeight.w500
                                 ),),
                             ),
                           ),
                         ),
                         SizedBox(height: 20,),
                         GestureDetector(
                           onTap: (){
                             answernow=true;
                             setState(() {

                             });
                           },
                           child: Container(
                             padding: EdgeInsets.all(12),
                             margin: EdgeInsets.only(right: 20, left: 20),
                             width: MediaQuery.of(context).size.width,
                             decoration: BoxDecoration(border: Border.all(color:answernow?answer==option[2].replaceAll(RegExp(r'[\[\]]'), '')? Colors.green: Colors.red: Colors.white38, width: 2), borderRadius: BorderRadius.circular(30)),
                             child: Center(
                               child: Text(
                                 option[2].replaceAll(RegExp(r'[\[\]]'), ''),
                                 textAlign: TextAlign.center,
                                 style: TextStyle(
                                     color: Colors.white,
                                     fontSize: 24,
                                     fontWeight: FontWeight.w500
                                 ),),
                             ),
                           ),
                         ),
                         SizedBox(height: 20,),
                         GestureDetector(
                           onTap: (){
                             answernow=true;
                             setState(() {

                             });
                           },
                           child: Container(
                             padding: EdgeInsets.all(12),
                             margin: EdgeInsets.only(right: 20, left: 20),
                             width: MediaQuery.of(context).size.width,
                             decoration: BoxDecoration(border: Border.all(color:answernow?answer==option[3].replaceAll(RegExp(r'[\[\]]'), '')? Colors.green: Colors.red: Colors.white38, width: 2), borderRadius: BorderRadius.circular(30)),
                             child: Center(
                               child: Text(
                                 option[3].replaceAll(RegExp(r'[\[\]]'), ''),
                                 textAlign: TextAlign.center,
                                 style: TextStyle(
                                     color: Colors.white,
                                     fontSize: 24,
                                     fontWeight: FontWeight.w500
                                 ),),
                             ),
                           ),
                         ),
                         SizedBox(height: 40,)
                       ],),
                     ),
                     SizedBox(height: 20),
                     ElevatedButton(
                       style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.black)),
                       onPressed: refreshQuiz,
                       child: Text('New Question',
                       style: TextStyle(color: Colors.white),
                       ),
                     ),
                   ],
                 ),
               )
             ],
           )
       ),
     );
   }
 }