import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext c) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainMenu());
  }
}

class Skin {
  String name, emoji; Color color;
  double speed; int price; bool owned;
  Skin(this.name,this.emoji,this.color,
  this.speed,this.price,{this.owned=false});
}
class LevelData {
  String name, emoji, desc;
  Color street, building; double traffic;
  LevelData(this.name,this.emoji,this.desc,
  this.street,this.building,this.traffic);
}

class MainMenu extends StatefulWidget{
  const MainMenu({super.key});
  @override State<MainMenu> createState()=>_MainMenuState();
}
class _MainMenuState extends State<MainMenu>{
  int coins=500, high=0, selSkin=0, selLevel=0;
  List<Skin> skins=[
    Skin('العادي','🛺',Colors.yellow,1.0,0,owned:true),
    Skin('عنتيل','🛺',Colors.red,1.2,1500),
    Skin('الطيارة','🚀',Colors.cyan,1.7,9000),
  ];
  List<LevelData> levels=[
    LevelData('الحارة','🏘️','سهلة',
    const Color(0xFF8D6E63),
    const Color(0xFFD7CCC8),0.02),
    LevelData('الدائري','🛣️','صعبة',
    const Color(0xFF212121),
    const Color(0xFF616161),0.06),
  ];
  @override void initState(){
    super.initState(); _load();
  }
  _load() async{
    var p=await SharedPreferences.getInstance();
    setState((){
      coins=p.getInt('coins')??500;
      high=p.getInt('tok_high')??0;
    });
  }
  _save() async{
    var p=await SharedPreferences.getInstance();
    p.setInt('coins',coins);
    p.setInt('tok_high',high);
  }
  @override Widget build(BuildContext c){
    return Scaffold(body: Container(
      decoration:const BoxDecoration(
        gradient:LinearGradient(
          colors:[Color(0xFFFF9800),Color(0xFFFF5722)])),
      child: SafeArea(child: Column(children:[
        const SizedBox(height:10),
        Row(mainAxisAlignment:MainAxisAlignment.spaceAround,
        children:[_chip('💰 $coins'), _chip('🏆 $high')]),
        const Text('🛺 سواق التوكتوك 🛺',
          style:TextStyle(fontSize:30,
          fontWeight:FontWeight.w900,color:Colors.white)),
        Expanded(child: ListView(
          padding:const EdgeInsets.all(16), children:[
          ElevatedButton(onPressed:(){
            Navigator.push(c, MaterialPageRoute(
              builder:(_)=>GameScreen(
                skin:skins[selSkin],
                level:levels[selLevel],
                levelIndex:selLevel,
                onFinish:(sc,earned){
                  setState((){
                    coins+=earned;
                    if(sc>high) high=sc;
                  }); _save();
                })));
          },
          style:ElevatedButton.styleFrom(
            backgroundColor:Colors.black,
            padding:const EdgeInsets.symmetric(vertical:18)),
          child:const Text('يلا نطلع مصلحة 🛺💨',
            style:TextStyle(color:Colors.white, fontSize:20))),
        ])),
      ]))));
  }
  Widget _chip(String t)=>Container(
    padding:const EdgeInsets.symmetric(horizontal:14,vertical:6),
    decoration:BoxDecoration(
      color:Colors.black87,
      borderRadius:BorderRadius.circular(20)),
    child:Text(t,
      style:const TextStyle(color:Colors.white)));
}

class GameObj{
  double x,y; String type; double speed;
  GameObj(this.x,this.y,this.type,this.speed);
}
class GameScreen extends StatefulWidget{
  final Skin skin; final LevelData level;
  final int levelIndex;
  final Function(int,int) onFinish;
  const GameScreen({super.key,
    required this.skin, required this.level,
    required this.levelIndex, required this.onFinish});
  @override State<GameScreen> createState()=>_GameScreenState();
}
class _GameScreenState extends State<GameScreen>{
  double toktokX=0.5, fuel=100;
  int score=0, lives=3, coinsEarned=0;
  double gameSpeed=4;
  bool left=false,right=false;
  List<GameObj> objs=[];
  Timer? loop; Random rnd=Random();

  @override void initState(){
    super.initState();
    loop=Timer.periodic(
      const Duration(milliseconds:16),(_){
      if(!mounted) return;
      setState((){
        if(left && toktokX>0.08)
          toktokX-=0.018*widget.skin.speed;
        if(right && toktokX<0.92)
          toktokX+=0.018*widget.skin.speed;
        fuel-=0.04;
        if(fuel<=0){_over('البنزين خلص!'); return;}
        for(var o in objs) o.y+=o.speed;
        objs.removeWhere((o)=>o.y>110);
        if(rnd.nextDouble()<widget.level.traffic){
          objs.add(GameObj(
            rnd.nextDouble()*0.8+0.1, -10, 'car', gameSpeed));
        }
        for(var o in List.from(objs)){
          if((o.x-toktokX).abs()<0.13 &&
            (o.y-85).abs()<8){
            objs.remove(o);
            if(o.type=='car'){
              lives--;
              if(lives<=0) _over('عملت حادثة!');
            } else {
              score+=20; coinsEarned+=10;
            }
          }
        }
        score++;
      });
    });
  }
  void _over(String r){
    loop?.cancel();
    widget.onFinish(score,coinsEarned);
    showDialog(context:context,
      barrierDismissible:false,
      builder:(c)=>AlertDialog(
        title:Text(r),
        content:Text('كسبت $coinsEarned'),
        actions:[ElevatedButton(
          onPressed:(){
            Navigator.pop(c);
            Navigator.pop(context);
          },
          child:const Text('تمام'))]));
  }
  @override void dispose(){
    loop?.cancel(); super.dispose();
  }
  @override Widget build(BuildContext context){
    var w=MediaQuery.of(context).size.width;
    return Scaffold(body: Stack(children:[
      Container(color:widget.level.building),
      Positioned.fill(child: CustomPaint(
        painter: RoadPainter(
          streetColor: widget.level.street))),
      for(var o in objs) Positioned(
        left:w*o.x-20,
        top:MediaQuery.of(context).size.height*o.y/100,
        child:const Text('🚗',
          style:TextStyle(fontSize:30))),
      Positioned(
        left:w*toktokX-30, bottom:110,
        child: Text(widget.skin.emoji,
          style:const TextStyle(fontSize:48))),
      Positioned(left:0, bottom:0, top:0, width:w*0.5,
        child: GestureDetector(
          onTapDown:(_)=>left=true,
          onTapUp:(_)=>left=false,
          onTapCancel:()=>left=false)),
      Positioned(right:0, bottom:0, top:0, width:w*0.5,
        child: GestureDetector(
          onTapDown:(_)=>right=true,
          onTapUp:(_)=>right=false,
          onTapCancel:()=>right=false)),
      Positioned(top:40, left:10,
        child: Text('❤️'*lives)),
      Positioned(top:40, right:10,
        child: Text('⛽ ${fuel.toStringAsFixed(0)}%')),
    ]));
  }
}
class RoadPainter extends CustomPainter{
  final Color streetColor;
  RoadPainter({required this.streetColor});
  @override void paint(Canvas c, Size s){
    var p=Paint()..color=streetColor;
    c.drawRect(
      Rect.fromLTWH(s.width*0.12,0,s.width*0.76,s.height),p);
  }
  @override bool shouldRepaint(c)=>false;
}
