import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'search.dart';
import 'news.dart';
import 'profile.dart';
import 'privatehos.dart';
import 'govhos.dart';
import 'supplyselect.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';


class HomePage extends StatefulWidget {
  final String userName;
  const HomePage({Key? key, required this.userName}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();

  int daysLeft = 0;
  bool isOverdue = false;

  @override
  void initState() {
    super.initState();
    _fetchLastBagChangeDate();
  }

  Future<void> _fetchLastBagChangeDate() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists && userDoc.data() != null) {
      // Retrieve the last bag change date
      Timestamp? lastChangeTimestamp = userDoc.get('lastBagChangeDate');
      if (lastChangeTimestamp != null) {
        DateTime lastChangeDate = lastChangeTimestamp.toDate();
        int difference = DateTime.now().difference(lastChangeDate).inDays;
        setState(() {
          daysLeft = 7 - difference;
          isOverdue = daysLeft < 0;
        });
      }
    }
  }
  // Save the last bag change date to Firebase Firestore for the current user
  Future<void> _saveLastBagChangeDate(DateTime date) async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";

    if (userId.isNotEmpty) {
      // Save the date in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'lastBagChangeDate': date,
      });
    }
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage()));
    } else if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => NewsPage()));
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(),
        ),
      );
    }
  }

  void _showDatePicker() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      // Save the selected date to Firestore
      await _saveLastBagChangeDate(selectedDate);

      // Re-fetch the updated data to reflect the new date
      await _fetchLastBagChangeDate();
    }
  }
  // Show the selection box dialog
  void _showHospitalSelectionDialog() {
    showDialog(
      context: context,
      barrierDismissible: true, // Allows tapping outside the dialog to close it
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent, // Transparent background for the dialog
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Select the Hospital Type",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HospitalListScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 80), // Increase the height
                    padding: EdgeInsets.symmetric(vertical: 9), // Add extra vertical padding
                    backgroundColor: Colors.white, // Button color
                  ),
                  child: Text(
                    "Private Hospitals",
                    style: TextStyle(
                      fontSize: 20, // Increase the font size
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GovernmentHospitalsScreen()), // Navigate to GovernmentHospitalsScreen
                    ); // Handle Government Hospital selection
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 80), // Increase the height
                    padding: EdgeInsets.symmetric(vertical: 9), // Add extra vertical padding
                    backgroundColor: Colors.white, // Button color
                  ),
                  child: Text(
                    "Government Hospitals",
                    style: TextStyle(
                      fontSize: 20, // Increase the font size
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.lightBlueAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Hello ${widget.userName} !",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/Logoostocare.png',
                          height: 70,
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Ostocare",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.deepPurple,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              SizedBox(height: 20),

              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TableCalendar(
                          focusedDay: _focusedDay,
                          firstDay: DateTime(2000),
                          lastDay: DateTime(2100),
                          calendarFormat: _calendarFormat,
                          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          },
                          headerStyle: HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                            titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          calendarStyle: CalendarStyle(
                            selectedDecoration: BoxDecoration(color: Colors.deepPurple, shape: BoxShape.circle),
                            todayDecoration: BoxDecoration(color: Colors.deepPurple.withOpacity(0.5), shape: BoxShape.circle),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 3,
                    left: 20,
                    right: 20,
                    child: GestureDetector(  // Change from just displaying text to making it clickable
                      onTap: _showDatePicker,  // Function to show date picker
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        child: Container(
                          color: isOverdue ? Colors.red : Colors.lightBlueAccent,
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Center(
                            child: Text(
                              "Days left for a bag change: $daysLeft",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 5,
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        "Track your progress today!",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: _showHospitalSelectionDialog, // Handle button press
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 5,
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              "Find hospitals and nurses near you!",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              alignment: Alignment.center,
                              child: Image.asset('assets/homepageimg2.png', fit: BoxFit.contain, width: 100, height: 100),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SupplySelectPage()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 5,
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              child: Center(
                                child: Image.asset('assets/homepageimg3.png', fit: BoxFit.contain, width: 100, height: 100),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: double.infinity,
                              child: Center(
                                child: Text(
                                  "Contact your supply agents!",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60,
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.home, size: 35, color: Colors.deepPurple),
                  onPressed: () => _onItemTapped(0),
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.search, size: 35, color: Colors.deepPurple),
                  onPressed: () => _onItemTapped(1),
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.article, size: 35, color: Colors.deepPurple),
                  onPressed: () => _onItemTapped(2),
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.account_circle, size: 35, color: Colors.deepPurple),
                  onPressed: () => _onItemTapped(3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}