//
// flutter pub add get
// flutter pub add flutter_reactive_ble
// android settings, app, give location permission for ble to work
//
// if flutter run complains about minSdkVersion then edit file android/app/build.gradle
//    look for minSdkVersion and change it to 21 (I think this is what flutter suggest at this time March 3, 2023)
//    this change might not be needed in the future if flutter creates changes to minSdkVersion

// filename: main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './blecontroller.dart';

final TextStyle myStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

void main() => runApp(GetMaterialApp(home: Home()));

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BleController ble = Get.put(BleController());
    return Scaffold(
        appBar: AppBar(
            title: Obx(() => Text('${ble.status1.value} ${ble.status2.value}',
                style: myStyle))),
        body: Center(
            child: Column(children: [
          const SizedBox(height: 50.0),
          ElevatedButton(
              onPressed: ble.connect,
              child: Obx(() => Text('${ble.status1.value} ${ble.status2.value}',
                  style: myStyle))),
          const SizedBox(height: 10.0),
          ElevatedButton(
              child: Obx(() => Text('${ble.startText}', style: myStyle)),
              onPressed: () => ble.sendData(0x74)),
          const SizedBox(height: 10.0),
          ElevatedButton(
              child: Text('Wyślij czas', style: myStyle),
              onPressed: () => ble.sendTime()),
          const SizedBox(height: 170.0),
          Obx(() => Text('${ble.timestampString}')),
          const SizedBox(height: 170.0),
          // Text('button status:', style: myStyle),
          // SizedBox(height: 10.0),
          // Obx(() => Text('${ble.buttonStatus.value}',
          //     style: TextStyle(
          //         fontSize: 80.0,
          //         color: Colors.red,
          //         fontWeight: FontWeight.bold))),
        ])));
  }
}
