import 'dart:math';
import 'package:flutter/material.dart';
void main() => runApp(const MyApp());
class MyApp extends StatelessWidget { const MyApp({super.key}); @override Widget build(BuildContext c) => const MaterialApp(debugShowCheckedModeBanner: false, home: Game()); }
class PlayerData { String name, team, pos; int power, price, age; String emoji, league; PlayerData(this.name,this.team,this.pos,this.power,this.price,this.age,this.emoji,this.league); }
class TeamData { String name, emoji; int power; String league; TeamData(this.name,this.emoji,this.power,this.league); }

class Game extends StatefulWidget { const Game({super.key}); @override State<Game> createState()=>_GameState(); }
class _GameState extends State<Game> {
  int coins = 7000; int trophies = 0; int week = 1; String myTeamName = 'الاهلي'; int myTeamPower = 80;
  List<String> leagues = ['الدوري المصري','الانجليزي','الليجا','ابطال اوروبا','ابطال افريقيا','كاس العالم'];
  int selLeague = 0;

  List<PlayerData> allPlayers = [
    PlayerData('محمد صلاح','ليفربول','هجوم',95,1200,32,'🇪🇬','الانجليزي'),
    PlayerData('هالاند','السيتي','هجوم',94,1300,24,'🇳🇴','الانجليزي'),
    PlayerData('مبابي','ريال مدريد','هجوم',93,1250,26,'🇫🇷','الليجا'),
    PlayerData('فينيسيوس','ريال مدريد','هجوم',90,1000,24,'🇧🇷','الليجا'),
    PlayerData('بيلينجهام','ريال مدريد','وسط',89,950,21,'🏴󠁧󠁢󠁥󠁮󠁧󠁿','الليجا'),
    PlayerData('دي بروين','السيتي','وسط',91,900,33,'🇧🇪','الانجليزي'),
    PlayerData('فان دايك','ليفربول','دفاع',88,700,33,'🇳🇱','الانجليزي'),
    PlayerData('كورتوا','ريال مدريد','حارس',87,600,32,'🇧🇪','الليجا'),
    PlayerData('زيزو','الزمالك','وسط',82,500,28,'🇪🇬','الدوري المصري'),
    PlayerData('امام عاشور','الاهلي','وسط',84,550,26,'🇪🇬','الدوري المصري'),
    PlayerData('وسام ابو علي','الاهلي','هجوم',80,450,25,'🇵🇸','الدوري المصري'),
    PlayerData('مصطفي محمد','نانت','هجوم',79,400,27,'🇪🇬','الدوري المصري'),
    PlayerData('مرموش','فرانكفورت','هجوم',81,480,25,'🇪🇬','الدوري المصري'),
    PlayerData('تريزيجيه','طرابزون','وسط',78,350,30,'🇪🇬','الدوري المصري'),
    PlayerData('بيرسي تاو','الاهلي','هجوم',80,400,30,'🇿🇦','ابطال افريقيا'),
    PlayerData('الشحات','الاهلي','وسط',79,380,32,'🇪🇬','ابطال افريقيا'),
    PlayerData('زيزو افريقيا','الزمالك','وسط',81,420,28,'🇪🇬','ابطال افريقيا'),
    PlayerData('ميسي','الارجنتين','هجوم',94,1400,37,'🇦🇷','كاس العالم'),
    PlayerData('رونالدو','البرتغال','هجوم',90,1100,39,'🇵🇹','كاس العالم'),
    PlayerData('نيمار','البرازيل','هجوم',88,900,32,'🇧🇷','كاس العالم'),
    PlayerData('ساكا','انجلترا','هجوم',86,800,23,'🏴󠁧󠁢󠁥󠁮󠁧󠁿','كاس العالم'),
    PlayerData('اوسيمين','نيجيريا','هجوم',85,750,25,'🇳🇬','كاس العالم'),
  ];

  List<TeamData> teams = [
    TeamData('الاهلي','🦅',80,'الدوري المصري'), TeamData('الزمالك','🏹',76,'الدوري المصري'), TeamData('بيراميدز','🔵',73,'الدوري المصري'),
    TeamData('ليفربول','🔴',88,'الانجليزي'), TeamData('السيتي','🩵',90,'الانجليزي'), TeamData('ارسنال','🔴',86,'الانجليزي'),
    TeamData('ريال مدريد','👑',91,'الليجا'), TeamData('برشلونة','🔵🔴',87,'الليجا'),
    TeamData('السيتي','🩵',90,'ابطال اوروبا'), TeamData('ريال مدريد','👑',91,'ابطال اوروبا'), TeamData('بايرن','🔴',88,'ابطال اوروبا'),
    TeamData('الاهلي','🦅',80,'ابطال افريقيا'), TeamData('الوداد','🔴',74,'ابطال افريقيا'), TeamData('صن داونز','🟡',75,'ابطال افريقيا'), TeamData('الترجي','🔴🟡',73,'ابطال افريقيا'),
    TeamData('مصر','🇪🇬',82,'كاس العالم'), TeamData('الارجنتين','🇦🇷',90,'كاس العالم'), TeamData('فرنسا','🇫🇷',89,'كاس العالم'), TeamData('البرازيل','🇧🇷',88,'كاس العالم'), TeamData('المغرب','🇲🇦',80,'كاس العالم'),
  ];

  List<PlayerData> mySquad = []; List<PlayerData> market = [];
  @override void initState(){ super.initState(); mySquad = allPlayers.where((p)=>p.team=='الاهلي').take(4).toList(); market = allPlayers; _calc(); }
  void _calc(){ if(mySquad.isEmpty) return; myTeamPower = mySquad.fold(0,(s,p)=>s+p.power) ~/ mySquad.length; }
  void buy(PlayerData p){ if(coins < p.price){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('فلوسك مش كفاية!'))); return; } if(mySquad.contains(p)) return; setState((){ coins-=p.price; mySquad.add(p); _calc(); }); }
  void sell(PlayerData p){ setState((){ coins+=(p.price*0.7).toInt(); mySquad.remove(p); _calc(); }); }
  void play(){
    var leagueTeams = teams.where((t)=>t.league==leagues[selLeague]).toList();
    if(leagueTeams.isEmpty) return;
    var enemy = leagueTeams[Random().nextInt(leagueTeams.length)]; if(enemy.name==myTeamName && leagueTeams.length>1) enemy = leagueTeams[(leagueTeams.indexOf(enemy)+1)%leagueTeams.length];
    int ep = enemy.power + Random().nextInt(12)-6; bool win = myTeamPower + Random().nextInt(12) > ep; bool draw =!win && Random().nextBool(); int reward = win? 600 : draw? 200 : 70; week++;
    showDialog(context: context, builder:(c)=>AlertDialog(title: Text('$myTeamName vs ${enemy.name} ${enemy.emoji}'), content: Column(mainAxisSize:MainAxisSize.min, children:[Text('🏆 ${leagues[selLeague]}', style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height:8), Text('قوتك $myTeamPower vs ${enemy.power}'), const SizedBox(height:8), Text(win?'فوز عظيم! 🎉':draw?'تعادل 🤝':'خسارة 😢', style: TextStyle(fontSize:22, fontWeight: FontWeight.bold, color: win? Colors.green:Colors.red)), Text('+$reward 💰')]), actions:[ElevatedButton(onPressed:(){ setState((){ coins+=reward; if(win) trophies++; }); Navigator.pop(c); }, child: const Text('تمام'))]));
  }
  Widget _chip(String t)=>Container(padding:const EdgeInsets.symmetric(horizontal:10,vertical:5), decoration:BoxDecoration(color:Colors.black87, borderRadius:BorderRadius.circular(20)), child:Text(t, style:const TextStyle(color:Colors.white, fontSize:11, fontWeight: FontWeight.bold)));
  @override Widget build(BuildContext context){
    return DefaultTabController(length:4, child: Scaffold(backgroundColor: const Color(0xFF0F2D1A),
      appBar: AppBar(backgroundColor: Colors.black, title: const Text('⚽ انت المدرب ULTIMATE', style: TextStyle(color: Colors.white, fontSize:14, fontWeight: FontWeight.bold)), bottom: const TabBar(isScrollable:true, tabs:[Tab(text:'فريقي (11)'),Tab(text:'الدوريات (6)'),Tab(text:'الانتقالات (23)'),Tab(text:'الماتشات')], labelColor: Colors.amber, unselectedLabelColor: Colors.white70)),
      body: Column(children:[
        Container(color:Colors.black87, padding:const EdgeInsets.all(8), child: Row(mainAxisAlignment:MainAxisAlignment.spaceAround, children:[_chip('💰 $coins'), _chip('🏆 $trophies'), _chip('💪 $myTeamPower'), _chip('📅 اسبوع $week')])),
        Expanded(child: TabBarView(children:[
          ListView(padding:const EdgeInsets.all(10), children:[ Container(padding:const EdgeInsets.all(12), decoration:BoxDecoration(color:Colors.amber, borderRadius:BorderRadius.circular(12)), child: Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children:[Text('$myTeamName 🦅 - التشكيلة', style: const TextStyle(fontWeight:FontWeight.w900, fontSize:16)), Text('$myTeamPower', style: const TextStyle(fontWeight: FontWeight.bold, fontSize:18))])), const SizedBox(height:10),...mySquad.map((p)=>Card(child: ListTile(leading: Text(p.emoji, style: const TextStyle(fontSize:26)), title: Text('${p.name} - ${p.pos}'), subtitle: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[Text('${p.team} | ${p.league} | قوة ${p.power}'), LinearProgressIndicator(value: p.power/100, color: p.power>88? Colors.green:Colors.orange)]), trailing: IconButton(icon: const Icon(Icons.sell, color: Colors.red), onPressed: ()=>sell(p))))),]),
          Column(children:[ SizedBox(height:45, child: ListView.builder(scrollDirection:Axis.horizontal, itemCount:leagues.length, itemBuilder:(c,i){ bool sel=i==selLeague; return GestureDetector(onTap:()=>setState(()=>selLeague=i), child: Container(margin:const EdgeInsets.all(5), padding:const EdgeInsets.symmetric(horizontal:16), decoration:BoxDecoration(color: sel? Colors.amber:Colors.white24, borderRadius:BorderRadius.circular(20)), child: Center(child: Text(leagues[i], style: TextStyle(color: sel?Colors.black:Colors.white, fontSize:12, fontWeight:FontWeight.bold))))); })), Expanded(child: ListView(children: teams.where((t)=>t.league==leagues[selLeague]).map((t)=>Card(color: t.name==myTeamName? Colors.yellow[100]:Colors.white, child: ListTile(leading: Text(t.emoji, style: const TextStyle(fontSize:28)), title: Text(t.name, style: const TextStyle(fontWeight:FontWeight.bold)), subtitle: Text('القوة: ${t.power} | ${t.league}'), trailing: t.name==myTeamName? const Text('فريقك', style: TextStyle(color:Colors.green, fontWeight:FontWeight.bold)):null))).toList()))]),
          ListView(padding:const EdgeInsets.all(8), children: allPlayers.where((p)=>selLeague==0 || p.league==leagues[selLeague] || leagues[selLeague]=='ابطال اوروبا').map((p)=>Card(color: mySquad.contains(p)? Colors.green[50]:Colors.white, child: ListTile(leading: Text(p.emoji), title: Text('${p.name} (${p.pos})', style: const TextStyle(fontWeight:FontWeight.bold, fontSize:13)), subtitle: Text('${p.team} | ${p.league}\nقوة ${p.power} | عمر ${p.age} | ${p.price} 💰', style: const TextStyle(fontSize:12)), trailing: mySquad.contains(p)? const Icon(Icons.check, color:Colors.green):ElevatedButton(onPressed: ()=>buy(p), style: ElevatedButton.styleFrom(minimumSize: const Size(70,35)), child: Text('شراء', style: const TextStyle(fontSize:11))), isThreeLine:true))).toList()),
          Center(child: Column(mainAxisAlignment:MainAxisAlignment.center, children:[ Text(leagues[selLeague].contains('العالم')?'🌍':leagues[selLeague].contains('افريقيا')?'🌍🏆':leagues[selLeague].contains('اوروبا')?'🏆':'🏟️', style: const TextStyle(fontSize:70)), const SizedBox(height:10), Text('تلعب في: ${leagues[selLeague]}', style: const TextStyle(color:Colors.white, fontSize:18, fontWeight:FontWeight.bold)), const SizedBox(height:6), Text('فريقك: $myTeamName - قوة $myTeamPower', style: const TextStyle(color:Colors.white70)), const SizedBox(height:20), ElevatedButton(onPressed: play, style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, padding: const EdgeInsets.symmetric(horizontal:50, vertical:18)), child: const Text('العب الماتش ⚽🔥', style: TextStyle(fontSize:20, fontWeight:FontWeight.bold, color:Colors.black))), const SizedBox(height:15), const Padding(padding: EdgeInsets.all(12), child: Text('نصيحة: اشتري لاعيبة من تبويب الانتقالات وغير الدوري من فوق عشان تلعب في افريقيا وكاس العالم!', style: TextStyle(color:Colors.white54, fontSize:12), textAlign:TextAlign.center))]))
        ]))
      ])));
  }
}
