import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';


class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 40);

    // Create wave effect
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 20);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 40);
    var secondEndPoint = Offset(size.width, size.height - 20);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class EnterScreen extends StatefulWidget {
  const EnterScreen({super.key});

  @override
  State<EnterScreen> createState() => _EnterScreenState();
}

class _EnterScreenState extends State<EnterScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top Section
              Stack(
                children: [
                  // Yellow background
                  ClipPath(
                    clipper: WaveClipper(),
                    child: Container(
                      width: screenWidth,
                      height: screenHeight * 0.52,
                      decoration: BoxDecoration(
                        gradient: const RadialGradient(
                          colors: [Color(0xFFDEE5FA), Color(0xFFFFE7B0)],
                        ),
                      ) ,
                      child: Stack(
                        children: [
                          // circles - LEFT
                          Positioned(
                            left: -screenWidth * 0.25,
                            top: screenHeight * 0.06,
                            child: Container(
                              width: screenWidth * 0.48,
                              height: screenWidth * 0.48,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEE7C9E).withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                                
                              ),
                            ),
                          ),
                          // circles - RIGHT
                          Positioned(
                            right: -screenWidth * 0.2,
                            top: screenHeight * 0.18,
                            child: Container(
                              width: screenWidth * 0.40,
                              height: screenWidth * 0.46,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEE7C9E).withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),

                          // Content
                          Column(
                            children: [
                              SizedBox(height: screenHeight * 0.021),

                              // Title "Quibble"
                              Text(
                                'Quibble',
                                style: TextStyle(
                                  color: const Color(0xFFEE7C9E),
                                  fontSize: screenWidth * 0.125,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.015),

                              // icon quibble
                              Container(
                                width: screenWidth * 0.5,
                                height: screenWidth * 0.5,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset(
                                    'assets/images/image.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.025),

                              // Tagline
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                                child: Text(
                                  'Grow Closer to His Word',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: screenWidth * 0.053,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w700,
                                    height: 1.25,
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.008),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.12),
                                child: Text(
                                  'Test your knowledge through inspiring Bible quizzes',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: screenWidth * 0.0335,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Form Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.09),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.01),

                    // Name Input Section
                    Text(
                      'What\'s your name?',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 0.046,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.012),

                    // Name TextField
                    Container(
                      height: screenHeight * 0.055,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFEDC2C9),
                          width: 1.5,
                        ),
                      ),
                      child: TextField(
                        controller: _nameController,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.035,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Type here',
                          hintStyle: TextStyle(
                            color: const Color(0xFF9E9E9E),
                            fontSize: screenWidth * 0.032,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenHeight * 0.015,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.018),

                    // Start Quiz Button
                    SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.056,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_nameController.text.trim().isNotEmpty) {
                            await _saveName();
                            if (context.mounted) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const HomeScreen())
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter your name'),
                                  backgroundColor: Color(0xFF6984D0),
                                )
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEE7C9E),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Start Quiz',
                          style: TextStyle(
                            fontSize: screenWidth * 0.041,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}