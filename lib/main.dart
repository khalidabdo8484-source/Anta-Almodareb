import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const RaknaApp());
}

class RaknaApp extends StatelessWidget {
  const RaknaApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ركنة',
      theme: ThemeData(fontFamily: 'Cairo', primaryColor: Colors.black),
      home: const RaknaMap(),
    );
  }
}

class RaknaMap extends StatefulWidget {
  const RaknaMap({super.key});
  @override
  State<RaknaMap> createState() => _RaknaMapState();
}

class _RaknaMapState extends State<RaknaMap> {
  GoogleMapController? mapController;
  Position? myPos;
  Set<Marker> markers = {};
  StreamSubscription? spotsSub;
  int myPoints = 12;
  bool isSearching = false;
  String? myActiveId;

  // بداية الخريطة - الزمالك
  static const CameraPosition _zamalek = CameraPosition(
    target: LatLng(30.0626, 31.2194),
    zoom: 16.5,
  );

  @override
  void initState() {
    super.initState();
    _getLocation();
    _listenToSpots();
  }

  Future<void> _getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    Position pos = await Geolocator.getCurrentPosition();
    setState(() => myPos = pos);
    mapController?.animateCamera(CameraUpdate.newLatLng(LatLng(pos.latitude, pos.longitude)));
  }

  void _listenToSpots() {
    // بيسمع أي ركنة جديدة هتفضى في آخر 10 دقايق بس
    spotsSub = FirebaseFirestore.instance
        .collection('spots')
        .where('created_at', isGreaterThan: Timestamp.fromDate(DateTime.now().subtract(const Duration(minutes: 10))))
        .where('status', isEqualTo: 'leaving')
        .snapshots()
        .listen((snapshot) {
      Set<Marker> newMarkers = {};
      for (var doc in snapshot.docs) {
        var data = doc.data();
        double lat = data['lat'];
        double lng = data['lng'];
        newMarkers.add(Marker(
          markerId: MarkerId(doc.id),
          position: LatLng(lat, lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(
            title: 'ركنة هتفضى! 🟢',
            snippet: 'دوس حجز - فاضل دقيقتين',
            onTap: () => _reserveSpot(doc.id),
          ),
        ));
      }
      setState(() => markers = newMarkers);
    });
  }

  Future<void> _iAmLeaving() async {
    if (myPos == null) return;
    var doc = await FirebaseFirestore.instance.collection('spots').add({
      'lat': myPos!.latitude,
      'lng': myPos!.longitude,
      'status': 'leaving',
      'user_id': 'user_${DateTime.now().millisecondsSinceEpoch}',
      'created_at': Timestamp.now(),
      'points_reward': 5,
    });
    setState(() {
      myActiveId = doc.id;
      myPoints += 5;
    });
    Fluttertoast.showToast(msg: "تم نشر ركنتك +5 نقاط! استنى اللي جاي", backgroundColor: Colors.black);
    // امسحها بعد 5 دقايق لو محدش حجزها
    Future.delayed(const Duration(minutes: 5), () {
      FirebaseFirestore.instance.collection('spots').doc(doc.id).delete();
    });
  }

  Future<void> _searchingForSpot() async {
    if (myPos == null) return;
    setState(() => isSearching = true);
    await FirebaseFirestore.instance.collection('searchers').add({
      'lat': myPos!.latitude,
      'lng': myPos!.longitude,
      'created_at': Timestamp.now(),
    });
    Fluttertoast.showToast(msg: "بندورلك على ركنة قريبة... هنبعتلك اشعار أول ما تفضى واحدة", backgroundColor: Colors.blue);

    // محاكاة اشعار بعد 3 ثواني لو فيه ركنة قريبة
    Timer(const Duration(seconds: 3), () {
      if (markers.isNotEmpty) {
        Fluttertoast.showToast(msg: "لقيتلك ركنة خضرا على الخريطة! دوس عليها واحجزها", backgroundColor: Colors.green, toastLength: Toast.LENGTH_LONG);
      }
    });
  }

  Future<void> _reserveSpot(String spotId) async {
    await FirebaseFirestore.instance.collection('spots').doc(spotId).update({'status': 'reserved'});
    Fluttertoast.showToast(msg: "تم الحجز! الركنة مستنياك دقيقتين - اتحرك بسرعة", backgroundColor: Colors.green);
    setState(() => isSearching = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _zamalek,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            markers: markers,
            onMapCreated: (c) => mapController = c,
          ),
          // الهيدر
          SafeArea(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('ركنة', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                    Text('ساعد تتساعد', style: TextStyle(color: Colors.white54, fontSize: 11)),
                  ]),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: Row(children: [
                      const Icon(Icons.stars, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text('$myPoints نقطة', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ]),
                  )
                ],
              ),
            ),
          ),
          // الزرارين الكبار
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [BoxShadow(blurRadius: 20, color: Colors.black26)],
              ),
              child: Column(
                children: [
                  if (myActiveId == null) ...[
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: _searchingForSpot,
                        style: ElevatedButton.styleFrom(backgroundColor: isSearching ? Colors.blue : Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(isSearching ? Icons.search : Icons.local_parking, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(isSearching ? 'بندورلك...' : 'بدور على ركنة', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: OutlinedButton(
                        onPressed: _iAmLeaving,
                        style: OutlinedButton.styleFrom(side: const BorderSide(width: 2), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                        child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.directions_car, color: Colors.black),
                          SizedBox(width: 8),
                          Text('طالع من ركنتي', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                        ]),
                      ),
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.green)),
                      child: const Row(children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8),
                        Expanded(child: Text('ركنتك منشورة والناس شايفاها - هتاخد +5 نقاط لما حد يركن مكانك', style: TextStyle(fontWeight: FontWeight.bold))),
                      ]),
                    ),
                    const SizedBox(height: 12),
                    TextButton(onPressed: () { FirebaseFirestore.instance.collection('spots').doc(myActiveId).delete(); setState(() => myActiveId = null); }, child: const Text('إلغاء النشر')),
                  ],
                  const SizedBox(height: 8),
                  const Text('ابدأ بالزمالك فقط - كل ما تبلغ عن ركنة تاخد أولوية', style: TextStyle(fontSize: 11, color: Colors.black54)),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: Colors.white,
        onPressed: _getLocation,
        child: const Icon(Icons.my_location, color: Colors.black),
      ),
    );
  }
}
