import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:health_app1/globals.dart';
import 'package:health_app1/screens/admin_panel.dart';
import 'package:health_app1/screens/doctor/main_page_doctor.dart';
import 'package:health_app1/screens/doctor_or_patient.dart';
import 'package:health_app1/screens/firebase_auth.dart';
import 'package:health_app1/screens/my_profile.dart';
import 'package:health_app1/screens/patient/appointments.dart';
import 'package:health_app1/screens/patient/doctor_profile.dart';
import 'package:health_app1/screens/patient/main_page_patient.dart';
import 'package:health_app1/screens/skip.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase for all platforms(android, ios, web)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform.copyWith(
      databaseURL: "https://fcm1-12d87-default-rtdb.firebaseio.com",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? user;

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }
  @override
  void initState() {
    super.initState();
    _getUser().then((_) {
      setState(() {}); // Rebuild when user is fetched
    });
  }

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => user == null
            ? const Skip()
            : const DoctorOrPatient(),
        '/login': (context) => const FireBaseAuth(),
        '/admin': (context) => AdminPanel(),
        '/home': (context) =>
            isDoctor ? const MainPageDoctor() : const MainPagePatient(),
        '/profile': (context) => const MyProfile(),
        '/MyAppointments': (context) => const Appointments(),
        '/DoctorProfile': (context) => DoctorProfile(),
      },
      theme: ThemeData(brightness: Brightness.light),
      debugShowCheckedModeBanner: false,
      // home: MainPageDoctor(),
      // home: ChatRoom(
      //   userId: '1234',
      // ),
    );
  }
}
