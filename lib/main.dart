import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());
class MyApp extends StatelessWidget { const MyApp({super.key}); @override Widget build(BuildContext c) => const MaterialApp(debugShowCheckedModeBanner: false, home: Game()); }

class PlayerData { String name, team, pos; int power, price, age; String emoji; PlayerData(this.name,this.team,this.pos,this.power,this.price,this.age,this.emoji); }
class TeamData { String name, emoji; int power; String league; TeamData(this.name,this.emoji,this.power,this.league); }

class Game extends StatefulWidget { const Game({super.key}); @override State<Game> createState()=>_GameState(); }
class _GameState extends State<Game> {
  int coins = 5000;
  int trophies = 0;
  int week = 1;
  String myTeamName = 'الاهلي';
  int myTeamPower = 78;

  List<String> leagues = ['الدوري المصري','الدوري الانجليزي','الليجا','دوري ابطال اوروبا'];
  int selLeague = 0;

  List<PlayerData> allPlayers = [
    PlayerData('محمد صلاح','ليفربول','هجوم',95,1200,32,'🇪🇬'),
    PlayerData('هالاند','السيتي','هجوم',94,1300,24,'🇳🇴'),
    PlayerData('مبابي','ريال مدريد','هجوم',93,1250,26,'🇫🇷'),
    PlayerData('فينيسيوس','ريال مدريد','هجوم',90,1000,24,'🇧🇷'),
    PlayerData('بيلينجهام','ريال مدريد','وسط',89,950,21,'🏴󠁧󠁢󠁥󠁮󠁧󠁿'),
    PlayerData('دي بروين','السيتي','وسط',91,900,33,'🇧🇪'),
    PlayerData('رودري','السيتي','وسط',88,800,28,'🇪🇸'),
    PlayerData('فان دايك','ليفربول','دفاع',88,700,33,'🇳🇱'),
    PlayerData('ارنولد','ليفربول','دفاع',85,650,26,'🏴󠁧󠁢󠁥󠁮󠁧󠁿'),
    PlayerData('كورتوا','ريال مدريد','حارس',87,600,32,'🇧🇪'),
    PlayerData('زيزو','الزمالك','وسط',82,500,28,'🇪🇬'),
    PlayerData('امام عاشور','الاهلي','وسط',84,550,26,'🇪🇬'),
    PlayerData('وسام ابو علي','الاهلي','هجوم',80,450,25,'🇵🇸'),
    PlayerData('مصطفي محمد','نانت','هجوم',79,400,27,'🇪🇬'),
    PlayerData('مرموش','فرانكفورت','هجوم',81,480,25,'🇪🇬'),
    PlayerData('تريزيجيه','طرابزون','وسط',78,350,30,'🇪🇬'),
  ];

  List<TeamData> teams = [
    TeamData('الاهلي','🦅',78,'الدوري المصري'),
    TeamData('الزمالك','🏹',75,'الدوري المصري'),
    TeamData('بيراميدز','🔵',72,'الدوري المصري'),
    TeamData('ليفربول','🔴',88,'الدوري الانجليزي'),
    TeamData('السيتي','🩵',90,'الدوري الانجليزي'),
    TeamData('ارسنال','🔴',86,'الدوري الانجليزي'),
    TeamData('ريال مدريد','👑',91,'الليجا'),
    TeamData('برشلونة','🔵🔴',87,'الليجا'),
  ];

  List<PlayerData> mySquad = [];
  List<PlayerData> market = [];

  @override
  void initState(){ super.initState(); mySquad = allPlayers.where((p)=>p.team=='الاهلي').toList(); if(mySquad.isEmpty) mySquad = allPlayers.sublist(10,14); market = allPlayers; _calcPower(); }

  void _calcPower(){ if(mySquad.isEmpty) return; myTeamPower = mySquad.fold(0,(s,p)=>s+p.power) ~/ mySquad.length; }

  void buyPlayer(PlayerData p){
    if(coins < p.price){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('فلوسك مش كفاية!'))); return; }
    if(mySquad.contains(p)){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اللاعب عندك اصلا!'))); return; }
    setState((){ coins -= p.price; mySquad.add(p); _calcPower(); });
  }
  void sellPlayer(PlayerData p){
    setState((){ coins += (p.price*0.7).toInt(); mySquad.remove(p); _calcPower(); });
  }

  void playLeagueMatch(){
    var leagueTeams = teams.where((t)=>t.league==leagues[selLeague]).toList();
    var enemy = leagueTeams[Random().nextInt(leagueTeams.length)];
    int enemyPower = enemy.power + Random().nextInt(10)-5;
    bool win = myTeamPower + Random().nextInt(10) > enemyPower;
    bool draw =!win && Random().nextBool();
    int reward = win? 500 : draw? 150 : 50;
    week++;
    showDialog(context: context, builder:(c)=>AlertDialog(
      title: Text('${myTeamName} vs ${enemy.name} ${enemy.emoji}'),
      content: Column(mainAxisSize: MainAxisSize.min, children:[
        Text('الدوري: ${leagues[selLeague]}', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height:10),
        Text('قوتك: $myTeamPower vs $enemyPower'),
        const SizedBox(height:10),
        Text(win? 'فوز عظيم! 🎉' : draw? 'تعادل 🤝' : 'خسارة 😢', style: TextStyle(fontSize:20, fontWeight: FontWeight.bold, color: win? Colors.green : Colors.red)),
        Text('كسبت: $reward كوين'),
        Text('الاسبوع: $week'),
      ]),
      actions:[ElevatedButton(onPressed:(){ setState((){ coins+=reward; if(win) trophies++; }); Navigator.pop(c); }, child: const Text('تمام'))],
    ));
  }

  Widget _chip(String t)=>Container(padding:const EdgeInsets.symmetric(horizontal:10,vertical:5), decoration:BoxDecoration(color:Colors.black87, borderRadius:BorderRadius.circular(20)), child:Text(t, style:const TextStyle(color:Colors.white, fontSize:12, fontWeight: FontWeight.bold)));

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F2D1A),
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('⚽ انت المدرب - النسخة الكاملة', style: TextStyle(color: Colors.white, fontSize:16)),
          bottom: const TabBar(tabs:[Tab(text:'فريقي'),Tab(text:'الدوريات'),Tab(text:'الانتقالات'),Tab(text:'الماتشات')], labelColor: Colors.amber, unselectedLabelColor: Colors.white70),
        ),
        body: Column(
          children:[
            Container(color:Colors.black87, padding:const EdgeInsets.all(8), child: Row(mainAxisAlignment:MainAxisAlignment.spaceAround, children:[_chip('💰 $coins'), _chip('🏆 $trophies'), _chip('💪 $myTeamPower'), _chip('📅 اسبوع $week')])),
            Expanded(child: TabBarView(children:[
              ListView(
                padding:const EdgeInsets.all(10),
                children:[
                  Container(padding:const EdgeInsets.all(12), decoration:BoxDecoration(color:Colors.amber, borderRadius:BorderRadius.circular(12)), child: Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children:[Text('$myTeamName 🦅', style: const TextStyle(fontWeight:FontWeight.w900, fontSize:20)), Text('متوسط القوة: $myTeamPower', style: const TextStyle(fontWeight: FontWeight.bold))])),
                  const SizedBox(height:10),
                 ...mySquad.map((p)=>Card(child: ListTile(
                    leading: Text(p.emoji, style: const TextStyle(fontSize:28)),
                    title: Text('${p.name} - ${p.pos}'),
                    subtitle: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[Text('${p.team} | عمر: ${p.age} | قوة: ${p.power}'), LinearProgressIndicator(value: p.power/100, color: p.power>85? Colors.green : Colors.orange)]),
                    trailing: IconButton(icon: const Icon(Icons.sell, color: Colors.red), onPressed: ()=>sellPlayer(p)),
                  ))),
                ],
              ),
              Column(children:[
                SizedBox(height:45, child: ListView.builder(scrollDirection:Axis.horizontal, itemCount:leagues.length, itemBuilder:(c,i){ bool sel=i==selLeague; return GestureDetector(onTap:()=>setState(()=>selLeague=i), child: Container(margin:const EdgeInsets.all(5), padding:const EdgeInsets.symmetric(horizontal:18), decoration:BoxDecoration(color: sel? Colors.amber : Colors.white24, borderRadius:BorderRadius.circular(20)), child: Center(child: Text(leagues[i], style: TextStyle(color: sel? Colors.black: Colors.white, fontWeight: FontWeight.bold))))); })),
                Expanded(child: ListView(
                  children: teams.where((t)=>t.league==leagues[selLeague]).map((t)=>Card(color: t.name==myTeamName? Colors.yellow[100] : Colors.white, child: ListTile(leading: Text(t.emoji, style: const TextStyle(fontSize:30)), title: Text(t.name, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text('القوة: ${t.power}'), trailing: Text(t.name==myTeamName? 'فريقك' : '', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold))))).toList(),
                )),
              ]),
              ListView(
                padding:const EdgeInsets.all(8),
                children: market.map((p)=>Card(
                  color: mySquad.contains(p)? Colors.green[50] : Colors.white,
                  child: ListTile(
                    leading: Text(p.emoji),
                    title: Text('${p.name} (${p.pos})', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${p.team} | قوة ${p.power} | ${p.age} سنة\nالسعر: ${p.price} 💰'),
                    trailing: mySquad.contains(p)? const Icon(Icons.check, color: Colors.green) : ElevatedButton(onPressed: ()=>buyPlayer(p), child: Text('شراء ${p.price}')),
                    isThreeLine: true,
                  ),
                )).toList(),
              ),
              Center(child: Column(mainAxisAlignment:MainAxisAlignment.center, children:[
                const Text('🏟️', style: TextStyle(fontSize:80)),
                const SizedBox(height:10),
                Text('الدوري الحالي: ${leagues[selLeague]}', style: const TextStyle(color: Colors.white, fontSize:18, fontWeight: FontWeight.bold)),
                const SizedBox(height:20),
                ElevatedButton(
                  onPressed: playLeagueMatch,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20)),
                  child: const Text('العب ماتش الدوري ⚽🔥', style: TextStyle(fontSize:20, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
                const SizedBox(height:20),
                const Text('اكسب 3 ماتشات ورا بعض وخد بطولة!', style: TextStyle(color: Colors.white70)),
              ])),
            ])),
          ],
        ),
      ),
    );
  }
}
