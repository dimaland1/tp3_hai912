import 'package:flutter/material.dart';

class ProfileHomePage extends StatelessWidget {
  const ProfileHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Home Page'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.quiz),
            onPressed: () => Navigator.pushNamed(context, '/quiz'),
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _getCard(),
            Positioned(
              top: 100,
              child: _getAvatar(),
            ),
          ],
        ),
      ),
    );
  }

  Container _getCard() {
    return Container(
      margin: const EdgeInsets.only(top: 150),
      padding: const EdgeInsets.all(20),
      width: 300,
      decoration: BoxDecoration(
        color: Colors.pink,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          SizedBox(height: 60),
          Text(
            'Jalal Azouzout',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'jalal@gmail.com',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Text(
            'twitter: xxxx',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Container _getAvatar() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
        image: const DecorationImage(
          image: AssetImage('assets/profile.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}