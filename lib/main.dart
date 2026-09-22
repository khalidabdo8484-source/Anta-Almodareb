import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainMenu(),
    );
  }
}

// بيانات اللاعب
class Player {
  String name;
  String emoji;
  int power;
  int level;
  Player(this.name, this.emoji, this.power, this.level);
}

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});
  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int coins = 1000;
  int trophies = 0;
  int teamPower = 45;
  int selectedFormation = 0;

  List<String> formations = ['4-4-2', '4-3-3', '3-5-2'];

  List<Player> myTeam = [
    Player('الحارس', '🧤', 50, 1),
    Player('الدفاع', '🛡️', 48, 1),
    Player('الوسط', '⚙️', 52, 1),
    Player('الهجوم', '⚽', 55, 1),
  ];

  void trainPlayer(int index) {
    if (coins < 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فلوسك مش كفاية!')),
      );
      return;
    }
    setState(() {
      coins -= 100;
      myTeam[index].power += 5;
      myTeam[index].level += 1;
      teamPower = myTeam.fold(0, (s, p) => s + p.power) ~/ myTeam.length;
    });
  }

  void playMatch() {
    int enemyPower = 40 + Random().nextInt(40);
    bool win = teamPower > enemyPower;
    int reward = win? 300 : 50;

    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(win? 'فزت! 🎉' : 'خسرت 😢'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('قوة فريقك: $teamPower'),
            Text('قوة الخصم: $enemyPower'),
            const SizedBox(height: 10),
            Text(win? 'كسبت $reward كوين!' : 'حاول تاني، كسبت $reward'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                coins += reward;
                if (win) trophies++;
              });
              Navigator.pop(c);
            },
            child: const Text('تمام'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D4F2B),
      body: SafeArea(
        child: Column(
          children: [
            // الهيدر
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.black87,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _chip('💰 $coins'),
                  _chip('🏆 $trophies'),
                  _chip('💪 $teamPower'),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '⚽ أنت المدرب ⚽',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            Text(
              'خطة: ${formations[selectedFormation]}',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 15),

            // التشكيلة
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: formations.length,
                itemBuilder: (c, i) {
                  bool sel = i == selectedFormation;
                  return GestureDetector(
                    onTap: () => setState(() => selectedFormation = i),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: sel? Colors.amber : Colors.white24,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          formations[i],
                          style: TextStyle(
                            color: sel? Colors.black : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 15),

            // فريقي
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: myTeam.length,
                itemBuilder: (c, i) {
                  var p = myTeam[i];
                  return Card(
                    child: ListTile(
                      leading: Text(p.emoji, style: const TextStyle(fontSize: 30)),
                      title: Text('${p.name} - لفل ${p.level}'),
                      subtitle: LinearProgressIndicator(
                        value: p.power / 100,
                        color: Colors.green,
                      ),
                      trailing: ElevatedButton(
                        onPressed: () => trainPlayer(i),
                        child: const Text('درب 100💰'),
                      ),
                    ),
                  );
                },
              ),
            ),

            // زر الماتش
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: playMatch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: const Text(
                    'العب الماتش ⚽🔥',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String t) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(t, style: const TextStyle(color: Colors.white)),
    );
  }
}
