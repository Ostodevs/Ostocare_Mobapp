import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'search.dart';
import 'news.dart';
import 'profile.dart';
import 'privatehos.dart';
import 'govhos.dart';
import 'supplyselect.dart';
import 'trackprogress.dart';
import 'chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:async';
import 'package:intl/intl.dart';


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

  List<DateTime> _highlightedDays = [];
  List<DateTime> upcomingDays = [];
  List<DateTime> overdueDays = [];
  DateTime? _lastBagChangeDate;
  int daysLeft = 0;
  bool isOverdue = false;
  bool _isImageOverlayVisible = false;
  bool _isHovering = false;
  double _rightPosition = 30.0;
  double _bottomPosition = 30.0;
  double _initialRightPosition = 30.0;
  double _initialBottomPosition = 30.0;
  bool _isDragging = false;
  DateTime? _lastTapTime;
  String greeting = '';
  String firebaseMessage = '';
  bool showGreeting = true;
  Timer? _messageSwitcherTimer;




  @override
  void initState() {
    super.initState();
    _fetchLastBagChangeDate();
    _setGreeting();
    _fetchFirebaseMessage();
    _startMessageSwitching();
  }

  void _setGreeting() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 0 && hour < 12) {
      greeting = 'Good Morning';
    } else if (hour >= 12 && hour < 19) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Hello';
    }
  }

  @override
  void dispose() {
    _messageSwitcherTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _startMessageSwitching() {
    _messageSwitcherTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (firebaseMessage.isNotEmpty) {
        setState(() {
          showGreeting = !showGreeting;
        });
      }
    });
  }

  Future<void> _fetchFirebaseMessage() async {
    try {
      FirebaseFirestore.instance
          .collection('appData')
          .doc('homemessages')
          .snapshots()
          .listen((docSnapshot) {
        if (docSnapshot.exists && docSnapshot.data() != null) {
          String? message = docSnapshot.get('custom1');
          if (message != null && message.isNotEmpty) {
            setState(() {
              firebaseMessage = message;
            });
          }
        }
      });
    } catch (e) {
      print('Error fetching global greeting: $e');
    }
  }


  Future<void> _fetchLastBagChangeDate() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection(
        'users').doc(userId).get();

    if (userDoc.exists && userDoc.data() != null) {
      Timestamp? lastChangeTimestamp = userDoc.get('lastBagChangeDate');
      if (lastChangeTimestamp != null) {
        DateTime lastChangeDate = lastChangeTimestamp.toDate();
        int difference = DateTime.now().difference(lastChangeDate).inDays;

        setState(() {
          daysLeft = 7 - difference;
          isOverdue = daysLeft < 0;
          _lastBagChangeDate = lastChangeDate;

          if (isOverdue) {
            overdueDays = List.generate(difference, (i) => lastChangeDate.add(Duration(days: i + 1)));
          } else {
            upcomingDays = List.generate(7, (i) => lastChangeDate.add(Duration(days: i + 1)));
          }

          _highlightedDays = [...upcomingDays, ...overdueDays];
        });
      }
    }
  }

  Future<void> _saveLastBagChangeDate(DateTime date) async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";

    if (userId.isNotEmpty) {
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
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SearchPage()));
    } else if (index == 2) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NewsPage()));
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
      await _saveLastBagChangeDate(selectedDate);
      await _fetchLastBagChangeDate();
    }
  }

  void _showImageOverlay() {
    setState(() {
      _isImageOverlayVisible = true;
    });
  }

  void _hideImageOverlay() {
    setState(() {
      _isImageOverlayVisible = false;
    });
  }


  void _showHospitalSelectionDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
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
                      MaterialPageRoute(
                          builder: (context) => PrivateHospitalPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 80),
                    padding: EdgeInsets.symmetric(vertical: 9),
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    "Private Hospitals",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GovernmentHospitalsScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 80),
                    padding: EdgeInsets.symmetric(vertical: 9),
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    "Government Hospitals",
                    style: TextStyle(
                      fontSize: 20,
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
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: _showImageOverlay,
                                child: Image.asset(
                                  'assets/Logoostocare.png',
                                  height: 70,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Ostocare',
                                style: TextStyle(
                                  fontFamily: 'DancingScript',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(left: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 200,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              showGreeting ? greeting : firebaseMessage,
                                              style: const TextStyle(
                                                fontSize: 25,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            if (!showGreeting)
                                              const SizedBox(height: 9),
                                            if (showGreeting)
                                              ConstrainedBox(
                                                constraints: BoxConstraints(maxWidth: 200),
                                                child: AutoSizeText(
                                                  widget.userName,
                                                  maxLines: 1,
                                                  minFontSize: 12,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontSize: 37,
                                                    color: Colors.deepPurple,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    'assets/Avatar1.png',
                                    height: 100,
                                    width: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 70.0, left: 16.0, right: 16.0),
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.chevron_left),
                                          onPressed: () {
                                            setState(() {
                                              _focusedDay = DateTime(
                                                _focusedDay.year,
                                                _focusedDay.month - 1,
                                              );
                                            });
                                          },
                                        ),
                                        Text(
                                          DateFormat.yMMMM().format(_focusedDay),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.chevron_right),
                                          onPressed: () {
                                            setState(() {
                                              _focusedDay = DateTime(
                                                _focusedDay.year,
                                                _focusedDay.month + 1,
                                              );
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    ToggleButtons(
                                      isSelected: [
                                        _calendarFormat == CalendarFormat.month,
                                        _calendarFormat == CalendarFormat.twoWeeks,
                                        _calendarFormat == CalendarFormat.week,
                                      ],
                                      onPressed: (int index) {
                                        setState(() {
                                          switch (index) {
                                            case 0:
                                              _calendarFormat = CalendarFormat.month;
                                              break;
                                            case 1:
                                              _calendarFormat = CalendarFormat.twoWeeks;
                                              break;
                                            case 2:
                                              _calendarFormat = CalendarFormat.week;
                                              break;
                                          }
                                        });
                                      },
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 8),
                                          child: Text('Month', style: TextStyle(fontSize: 12)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 8),
                                          child: Text('Two Weeks', style: TextStyle(fontSize: 12)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 8),
                                          child: Text('Week', style: TextStyle(fontSize: 12)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  height: _calendarFormat == CalendarFormat.month
                                      ? 280
                                      : _calendarFormat == CalendarFormat.twoWeeks
                                      ? 180
                                      : 90,
                                    child: TableCalendar(
                                      focusedDay: _focusedDay,
                                      firstDay: DateTime(2000),
                                      lastDay: DateTime(2100),
                                      calendarFormat: _calendarFormat,
                                      headerVisible: false,
                                      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                                      onDaySelected: (selectedDay, focusedDay) {
                                        setState(() {
                                          _selectedDay = selectedDay;
                                          _focusedDay = focusedDay;
                                        });
                                      },
                                      eventLoader: (day) => [],
                                      calendarBuilders: CalendarBuilders(
                                        defaultBuilder: (context, day, focusedDay) {
                                          bool isOverdueDay = overdueDays.any((d) => isSameDay(d, day));
                                          bool isUpcomingDay = upcomingDays.any((d) => isSameDay(d, day));

                                          if (isOverdueDay) {
                                            return Container(
                                              margin: const EdgeInsets.all(6.0),
                                              decoration: BoxDecoration(
                                                color: Colors.red.withOpacity(0.5),
                                                shape: BoxShape.circle,
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                '${day.day}',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            );
                                          } else if (isUpcomingDay) {
                                            return Container(
                                              margin: const EdgeInsets.all(6.0),
                                              decoration: BoxDecoration(
                                                color: Colors.green.withOpacity(0.5),
                                                shape: BoxShape.circle,
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                '${day.day}',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            );
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 20,
                        right: 20,
                        child: GestureDetector(
                          onTap: _showDatePicker,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            child: Container(
                              color: isOverdue ? Colors.red : Colors.lightBlueAccent,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Center(
                                child: Text(
                                  isOverdue
                                      ? "Overdue by ${-daysLeft} days"
                                      : "Days left for a bag change: $daysLeft",
                                  style: const TextStyle(
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
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              TrackProgress()),
                        );
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 5,
                        child: Container(
                          height: 60,
                          width: double.infinity,
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: Text(
                              "Track your progress today!",
                              style: TextStyle(fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: _showHospitalSelectionDialog,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
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
                                  style: TextStyle(fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Image.asset('assets/homepageimg2.png',
                                      fit: BoxFit.contain,
                                      width: 100,
                                      height: 100),
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
                        MaterialPageRoute(
                            builder: (context) => SupplySelectPage()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
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
                                    child: Image.asset(
                                        'assets/homepageimg3.png',
                                        fit: BoxFit.contain,
                                        width: 100,
                                        height: 100),
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
                                      style: TextStyle(fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurple),
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
                  SizedBox(height: 20),
                ],
               ),
              ),
            ),
          ),
          if (_isImageOverlayVisible)
            GestureDetector(
              onTap: _hideImageOverlay,
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Large Image
                            Image.asset(
                              'assets/Logoostocare.png',
                              width: 200, // Adjust image size as needed
                              height: 200,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: 20),

                            // About Us Text
                            Text(
                              "About Us",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "We are the creators of this comprehensive platform, designed to support individuals facing health challenges. "
                                  "We understand the daily struggles you endure in this ongoing fight, and we have made it our mission to stand alongside you. "
                                  "Remember, you are not alone in this journey, We are here to support you in every step of the way.\n\n"
                                  "~ Ostocare family",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          // Inside the Stack in your HomePage build method
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
            right: _rightPosition,
            bottom: _bottomPosition,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _rightPosition -= details.delta.dx;
                  _bottomPosition -= details.delta.dy;

                  final screenWidth = MediaQuery.of(context).size.width;
                  final screenHeight = MediaQuery.of(context).size.height;
                  const bubbleSize = 70.0;
                  const headerHeight = 100.0;

                  _rightPosition = _rightPosition.clamp(0.0, screenWidth - bubbleSize);
                  _bottomPosition = _bottomPosition.clamp(0.0, screenHeight - bubbleSize - headerHeight);
                });
              },
              onPanEnd: (_) {
                final screenWidth = MediaQuery.of(context).size.width;
                final bubbleMidX = screenWidth - _rightPosition - 35;

                setState(() {
                  if (bubbleMidX > screenWidth / 2) {
                    _rightPosition = 10.0; // Snap to right
                  } else {
                    _rightPosition = screenWidth - 80.0; // Snap to left
                  }
                });
              },
              onDoubleTap: () {
                setState(() {
                  _rightPosition = 30.0;
                  _bottomPosition = 30.0;
                });
              },
              onTap: () {
                // Navigate to the Chat screen when tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatScreen()),
                );
              },
              child: MouseRegion(
                onEnter: (_) => setState(() => _isHovering = true),
                onExit: (_) => setState(() => _isHovering = false),
                child: ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.03),
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withOpacity(0.25),
                            Colors.transparent,
                          ],
                          center: Alignment.topLeft,
                          radius: 0.9,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.35),
                            blurRadius: 18,
                            spreadRadius: 2,
                            offset: Offset(-2, -2),
                          ),
                          BoxShadow(
                            color: Colors.lightBlueAccent.withOpacity(0.2),
                            blurRadius: 14,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.chat,
                        size: 36,
                        color: Colors.green.withOpacity(0.9),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
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
                  icon: Icon(
                      Icons.account_circle, size: 35, color: Colors.deepPurple),
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
