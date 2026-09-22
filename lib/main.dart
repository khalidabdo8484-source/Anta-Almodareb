import 'package:flutter/material.dart';

void main() => runApp(const AntaAlModarebApp());

class AntaAlModarebApp extends StatelessWidget {
  const AntaAlModarebApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: const Color(0xFF0F1420)),
      home: const Directionality(textDirection: TextDirection.rtl, child: MainGame()),
    );
  }
}

class MainGame extends StatefulWidget {
  const MainGame({super.key});
  @override State<MainGame> createState() => _MainGameState();
}

class _MainGameState extends State<MainGame> {
  int navIndex = 0;
  String formation = "4-3-3";
  String selectedLeague = "الدوري المصري";

  final leagues = {
    "الدوري المصري": [
      ["1", "الأهلي", "38", "85"], ["2", "بيراميدز", "38", "78"], ["3", "الزمالك", "38", "72"], ["4", "المصري", "38", "60"], ["5", "مودرن", "38", "55"]
    ],
    "الدوري الإنجليزي": [
      ["1", "Man City", "38", "91"], ["2", "Arsenal", "38", "89"], ["3", "Liverpool", "38", "82"], ["4", "Chelsea", "38", "71"], ["5", "Man Utd", "38", "68"]
    ],
    "دوري الأبطال": [
      ["1", "Real Madrid", "6", "15"], ["2", "Man City", "6", "12"], ["3", "Bayern", "6", "12"], ["4", "الأهلي", "6", "9"], ["5", "Inter", "6", "8"]
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            Expanded(child: _getPage()),
            _bottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _topBar() => Padding(
    padding: const EdgeInsets.all(8),
    child: Row(children: [
      Container(padding: const EdgeInsets.all(10), decoration: const BoxDecoration(color: Color(0xFF1E2740), shape: BoxShape.circle), child: const Icon(Icons.shield, size: 18)),
      const SizedBox(width: 6),
      _badge("الخزينة\n15246.0k ج.م", Colors.greenAccent, const Color(0xFF12332B)),
      const SizedBox(width: 6),
      _badge("المستوى 11\n100 ⭐", Colors.amber, const Color(0xFF3B2110)),
      const Spacer(),
      Container(padding: const EdgeInsets.all(10), decoration: const BoxDecoration(color: Color(0xFF1E2740), shape: BoxShape.circle), child: const Icon(Icons.notifications_none, size: 18)),
    ]),
  );

  Widget _badge(String t, Color c, Color bg) => Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)), child: Text(t, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: c)));

  Widget _getPage() {
    if (navIndex == 0) return _homePage();
    if (navIndex == 1) return _tacticsPage();
    if (navIndex == 2) return _matchesPage();
    if (navIndex == 3) return _squadPage();
    if (navIndex == 4) return _leaguePage();
    return _morePage();
  }

  // الصفحة الرئيسية - نفس الصورة بتاعتك
  Widget _homePage() => ListView(padding: const EdgeInsets.all(12), children: [
    Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFF1E2740), borderRadius: BorderRadius.circular(20)), child: Column(children: [
      const Row(children: [Icon(Icons.calendar_today, color: Colors.cyanAccent, size: 18), SizedBox(width: 8), Text("الأحد 22 أغسطس 2032 - الموسم 7", style: TextStyle(fontWeight: FontWeight.bold))]),
      const SizedBox(height: 10),
      Text("باقي 7 أيام على خوض الجولة 3", style: TextStyle(color: Colors.grey[400], fontSize: 12)),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2A3558)), onPressed: (){setState(()=>navIndex=2);}, child: const Text("عرض المباريات"))),
        const SizedBox(width: 10),
        Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF59E0B), foregroundColor: Colors.black), onPressed: (){}, child: const Text("تخطي للمباراة ⏩", style: TextStyle(fontWeight: FontWeight.bold)))),
      ])
    ])),
    const SizedBox(height: 12),
    Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFF1E2740), borderRadius: BorderRadius.circular(16)), child: const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("🏟️ في ملعبنا"), Text("الجولة 3 من 43", style: TextStyle(color: Colors.orangeAccent))])),
  ]);

  Widget _tacticsPage() => ListView(padding: const EdgeInsets.all(16), children: [
    const Text("اختر الخطة", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    const SizedBox(height: 12),
    Wrap(spacing: 8, children: ["4-3-3", "4-4-2", "3-5-2", "4-2-3-1"].map((f) => ChoiceChip(label: Text(f), selected: formation==f, onSelected: (v){setState(()=>formation=f);}, selectedColor: const Color(0xFF0E4D3A))).toList()),
    const SizedBox(height: 20),
    const Text("أسلوب اللعب", style: TextStyle(fontWeight: FontWeight.bold)),
    const SizedBox(height: 8),
    _tacticTile("هجوم ضاغط 🔥", "ضغط عالي واستحواذ"),
    _tacticTile("متوازن", "دفاع وهجوم متوازن"),
    _tacticTile("دفاع وركنيات", "ركن الباص والمرتدات"),
  ]);

  Widget _tacticTile(String title, String sub) => Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFF1E2740), borderRadius: BorderRadius.circular(12)), child: ListTile(title: Text(title), subtitle: Text(sub, style: const TextStyle(fontSize: 11, color: Colors.grey)), trailing: const Icon(Icons.check_circle_outline)));

  Widget _matchesPage() => ListView(padding: const EdgeInsets.all(12), children: [
    for(int i=0; i<5; i++) Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFF1E2740), borderRadius: BorderRadius.circular(14)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(i==0? "الأهلي" : "الزمالك", style: const TextStyle(fontWeight: FontWeight.bold)), Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: const Color(0xFF2A3558), borderRadius: BorderRadius.circular(8)), child: Text(i==0? "اليوم" : "${i+1} أيام", style: const TextStyle(fontSize: 12))), Text(i==0? "بيراميدز" : "المصري")])),
  ]);

  Widget _squadPage() {
    List<String> players = formation=="4-3-3"? ["حارس", "دفاع", "دفاع", "دفاع", "دفاع", "وسط", "وسط", "وسط", "هجوم", "هجوم", "هجوم"] : ["حارس", "دفاع", "دفاع", "وسط", "وسط", "وسط", "وسط", "هجوم", "هجوم"];
    return Column(children: [
      Padding(padding: const EdgeInsets.all(12), child: Text("التشكيلة: $formation", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
      Expanded(child: Container(margin: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFF1B5E20), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white24)), child: GridView.count(crossAxisCount: 3, padding: const EdgeInsets.all(12), children: players.map((p) => Card(color: const Color(0xFF1E2740), child: Center(child: Text(p)))).toList()))),
    ]);
  }

  Widget _leaguePage() => Column(children: [
    SingleChildScrollView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.all(8), child: Row(children: leagues.keys.map((l) => Padding(padding: const EdgeInsets.only(left: 6), child: ChoiceChip(label: Text(l), selected: selectedLeague==l, onSelected: (v){setState(()=>selectedLeague=l);})) ).toList())),
    Expanded(child: Container(margin: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFF1E2740), borderRadius: BorderRadius.circular(16)), child: ListView(children: [
      const Padding(padding: EdgeInsets.all(12), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("#"), Text("الفريق"), Text("لعب"), Text("نقط")])),
      const Divider(color: Colors.white12),
     ...leagues[selectedLeague]!.map((row) => Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(row[0]), Expanded(child: Text(row[1], textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))), Text(row[2]), Text(row[3], style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold))]))).toList()
    ]))),
  ]);

  Widget _morePage() => ListView(padding: const EdgeInsets.all(16), children: [for(var t in ["الانتقالات", "المالية", "الإعدادات", "المتجر"]) ListTile(title: Text(t), trailing: const Icon(Icons.arrow_forward_ios, size: 14), tileColor: const Color(0xFF1E2740), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))) ]);

  Widget _bottomNav() => Container(color: const Color(0xFF1A2238), padding: const EdgeInsets.symmetric(vertical: 6), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
    _navBtn(Icons.grid_view, "الرئيسية", 0),
    _navBtn(Icons.tune, "التكتيك", 1),
    _navBtn(Icons.sports, "المباريات", 2),
    _navBtn(Icons.groups, "التشكيلة", 3),
    _navBtn(Icons.emoji_events, "الدوري", 4),
    _navBtn(Icons.more_horiz, "المزيد", 5),
  ]));

  Widget _navBtn(IconData icon, String label, int index) => GestureDetector(on
