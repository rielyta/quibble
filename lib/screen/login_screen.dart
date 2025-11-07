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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: isLandscape
              ? _buildLandscapeLayout(context, screenWidth, screenHeight)
              : _buildPortraitLayout(context, screenWidth, screenHeight),
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context, double screenWidth, double screenHeight) {
    return Column(
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
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    colors: [Color(0xFFDEE5FA), Color(0xFFFFE7B0)],
                  ),
                ),
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
                            padding: EdgeInsets.all(screenWidth * 0.025),
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
        _buildFormSection(context, screenWidth, screenHeight, false),
      ],
    );
  }

  // Layout Landscape
  Widget _buildLandscapeLayout(BuildContext context, double screenWidth, double screenHeight) {
    return Row(
      children: [
        // Left Section - Hero Image
        Expanded(
          flex: 5,
          child: Stack(
            children: [
              ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  width: double.infinity,
                  height: screenHeight,
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      colors: [Color(0xFFDEE5FA), Color(0xFFFFE7B0)],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // circles - LEFT
                      Positioned(
                        left: -screenWidth * 0.08,
                        top: screenHeight * 0.05,
                        child: Container(
                          width: screenHeight * 0.25,
                          height: screenHeight * 0.25,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEE7C9E).withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      // circles - RIGHT
                      Positioned(
                        right: -screenWidth * 0.05,
                        top: screenHeight * 0.35,
                        child: Container(
                          width: screenHeight * 0.22,
                          height: screenHeight * 0.22,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEE7C9E).withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),

                      // Content
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Title "Quibble"
                            Text(
                              'Quibble',
                              style: TextStyle(
                                color: const Color(0xFFEE7C9E),
                                fontSize: screenHeight * 0.12,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.02),

                            // icon quibble
                            Container(
                              width: screenHeight * 0.35,
                              height: screenHeight * 0.35,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(screenHeight * 0.025),
                                child: Image.asset(
                                  'assets/images/image.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.03),

                            // Tagline
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                              child: Text(
                                'Grow Closer to His Word',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: screenHeight * 0.048,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w700,
                                  height: 1.25,
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                              child: Text(
                                'Test your knowledge through inspiring Bible quizzes',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: screenHeight * 0.032,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w400,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Right Section - Form
        Expanded(
          flex: 5,
          child: Center(
            child: SingleChildScrollView(
              child: _buildFormSection(context, screenWidth, screenHeight, true),
            ),
          ),
        ),
      ],
    );
  }

  // Form Section
  Widget _buildFormSection(BuildContext context, double screenWidth, double screenHeight, bool isLandscape) {
    final horizontalPadding = isLandscape ? screenWidth * 0.08 : screenWidth * 0.09;
    final maxWidth = isLandscape ? screenWidth * 0.35 : double.infinity;

    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: isLandscape ? screenHeight * 0.05 : screenHeight * 0.01),

          // Name Input Section
          Text(
            'What\'s your name?',
            style: TextStyle(
              color: Colors.black,
              fontSize: isLandscape ? screenHeight * 0.055 : screenWidth * 0.046,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: screenHeight * 0.012),

          // Name TextField
          Container(
            height: isLandscape ? screenHeight * 0.09 : screenHeight * 0.055,
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
                fontSize: isLandscape ? screenHeight * 0.04 : screenWidth * 0.035,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Type here',
                hintStyle: TextStyle(
                  color: const Color(0xFF9E9E9E),
                  fontSize: isLandscape ? screenHeight * 0.035 : screenWidth * 0.032,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: isLandscape ? screenWidth * 0.02 : screenWidth * 0.04,
                  vertical: screenHeight * 0.015,
                ),
              ),
            ),
          ),

          SizedBox(height: screenHeight * 0.018),

          // Start Quiz Button
          SizedBox(
            width: double.infinity,
            height: isLandscape ? screenHeight * 0.09 : screenHeight * 0.056,
            child: ElevatedButton(
              onPressed: () async {
                if (_nameController.text.trim().isNotEmpty) {
                  await _saveName();
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please enter your name',
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                      backgroundColor: const Color(0xFF6984D0),
                    ),
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
                  fontSize: isLandscape ? screenHeight * 0.045 : screenWidth * 0.041,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          SizedBox(height: screenHeight * 0.03),
        ],
      ),
    );
  }
}