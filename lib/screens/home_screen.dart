import 'package:flutter/material.dart';
import 'package:untitled/screens/loading_screen.dart';
import 'package:untitled/theme_notifier.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool isDarkMode = false;
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _scale = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _glow = Tween<double>(begin: 6.0, end: 20.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF1A1F36) : const Color(0xFFF2F2F7),
      appBar: AppBar(
        backgroundColor: isDarkMode ? const Color(0xFF1A1F36) : const Color(0xFFF2F2F7),
        elevation: 0,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color(0xFF2A2F4A)
                  : Color.fromRGBO(11, 15, 25, 0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
              icon: Icon(
                isDarkMode ? Icons.light_mode : Icons.dark_mode_outlined,
                size: 40,
                color: isDarkMode ? Colors.orange : Colors.black,
              ),
              onPressed: () {
                setState(() {
                  isDarkMode = !isDarkMode;
                });
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/ns3.png",
                width: 230,
                height: 210,
              ),
              SizedBox(height: 24),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Météo",
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: "  App",
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),

              Text(
                "Ta météo, partout dans le monde, en un clin d'œil ⚡",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 40),

              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.3 + (_glow.value / 40)),
                          blurRadius: 20 + _glow.value,
                          spreadRadius: 2 + (_glow.value / 6),
                          offset: Offset(0, 4),
                        ),
                        BoxShadow(
                          color: Colors.orangeAccent.withOpacity(0.15),
                          blurRadius: 40 + _glow.value,
                          spreadRadius: 6 + (_glow.value / 4),
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoadingScreen(), // ✅
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        "Lancer l'expérience",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}