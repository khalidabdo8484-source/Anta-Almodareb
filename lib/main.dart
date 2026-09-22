import 'package:flutter/material.dart';

void main() => runApp(const AntaAlModarebApp());

class AntaAlModarebApp extends StatelessWidget {
  const AntaAlModarebApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: const Color(0xFF0F1420)),
      home: const Directionality(textDirection: TextDirection.rtl, child: HomeScreen()),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar زي الصورة بالظبط
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  _topIcon(Icons.shield, hasLogo: true),
                  const SizedBox(width: 6),
                  _topBadgeGreen("الخزينة\n15246.0k ج.م", Icons.account_balance_wallet),
                  const SizedBox(width: 6),
                  _topBadgeOrange("المستوى 11\n100", Icons.star),
                  const SizedBox(width: 6),
                  _topIcon(Icons.notifications_none),
                  const SizedBox(width: 6),
                  _topIcon(Icons.keyboard_arrow_down, bg: Color(0xFF0E4D3A)),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  // كارت فيسبوك
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2740),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue.withOpacity(0.3))
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(color: const Color(0xFF2A3558), borderRadius: BorderRadius.circular(12)),
                              child: const Icon(Icons.chat_bubble_outline, color: Colors.blueAccent),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("تابع صفحة أنت المدرب على فيسبوك", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  SizedBox(height: 4),
                                  Text("خليك أول واحد يعرف التحديثات والبطولات والأخبار...", style: TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(color: const Color(0xFF2A3558), borderRadius: BorderRadius.circular(20)),
                              child: const Text("مجتمع اللعبة", style: TextStyle(fontSize: 11, color: Colors.blueAccent)),
                            )
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3A5BFF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 12)),
                            onPressed: (){}, icon: const Icon(Icons.open_in_new, size: 18), label: const Text("تابعنا على فيسبوك"),
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // كارت التاريخ والمباراة
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: const Color(0xFF1E2740), borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: const Color(0xFF0E4D3A), borderRadius: BorderRadius.circular(8)), child: const Text("الموسم 7", style: TextStyle(fontSize: 12))),
                                const SizedBox(width: 8),
                                const Text("الأحد 22 أغسطس 2032", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              ],
                            ),
                            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFF2A3558), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.calendar_today_outlined, color: Colors.cyanAccent)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text("باقي 7 أيام على خوض الجولة 3", style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2A3558), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                onPressed: (){}, icon: const Icon(Icons.timer_outlined, size: 18), label: const Text("اليوم التالي (1+)"),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF59E0B), foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                onPressed: (){},
                                child: const Text("تخطي سريع\nلموعد المباراة ⏩", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: Colors.white12),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("كثافة الحصص التدريبية اليومية:", style: TextStyle(fontSize: 12, color: Colors.grey)),
                            Row(children: [
                              _trainChip("استشفاء خفيف", false),
                              const SizedBox(width: 6),
                              _trainChip("متوازن وعادي", true),
                              const SizedBox(width: 6),
                              _trainChip("شاق ومكثف 🔥", false),
                            ])
                          ],
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFF1E2740), borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(20)), child: const Text("🏟️ في ملعبنا")),
                        const Text("الجولة 3 من 43", style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                ],
              ),
            ),

            // Bottom Nav زي الصورة
            Container(
              color: const Color(0xFF1A2238),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(Icons.grid_view, "الرئيسية", true),
                  _navItem(Icons.tune, "التكتيك", false),
                  _navItem(Icons.sports, "المباريات", false),
                  _navItem(Icons.groups, "التشكيلة", false),
                  _navItem(Icons.emoji_events_outlined, "الدوري", false),
                  _navItem(Icons.more_horiz, "المزيد", false),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _topBadgeOrange(String text, IconData icon) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(color: const Color(0xFF3B2110), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.orange.withOpacity(0.3))),
    child: Row(children: [const Icon(Icons.star, color: Colors.amber, size: 18), const SizedBox(width: 4), Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))]),
  );

  Widget _topBadgeGreen(String text, IconData icon) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(color: const Color(0xFF12332B), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.green.withOpacity(0.3))),
    child: Row(children: [const Icon(Icons.account_balance_wallet_outlined, color: Colors.greenAccent, size: 16), const SizedBox(width: 4), Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))]),
  );

  Widget _topIcon(IconData icon, {bool hasLogo=false, Color bg=const Color(0xFF1E2740)}) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
    child: Icon(icon, size: 18),
  );

  Widget _trainChip(String text, bool selected) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(color: selected? const Color(0xFF0E4D3A) : const Color(0xFF2A3558), borderRadius: BorderRadius.circular(8), border: selected? Border.all(color: Colors.greenAccent) : null),
    child: Text(text, style: TextStyle(fontSize: 11, color: selected? Colors.greenAccent : Colors.grey)),
  );

  Widget _navItem(IconData icon, String label, bool selected) => Column(
    children: [
      Icon(icon, color: selected? Colors.greenAccent : Colors.grey, size: 24),
      Text(label, style: TextStyle(fontSize: 10, color: selected? Colors.greenAccent : Colors.grey)),
      if(selected) Container(margin: const EdgeInsets.only(top: 2), height: 3, width: 20, decoration: BoxDecoration(color: Colors.greenAccent, borderRadius: BorderRadius.circular(2)))
    ],
  );
}
