import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';

class BleController {
  final frb1 = FlutterReactiveBle();
  final frb2 = FlutterReactiveBle();
  late StreamSubscription<ConnectionStateUpdate> c1;
  late StreamSubscription<ConnectionStateUpdate> c2;
  late QualifiedCharacteristic tx1;
  late QualifiedCharacteristic rx1;
  late QualifiedCharacteristic tx2;
  late QualifiedCharacteristic rx2;
  final devId1 = '28:CD:C1:00:05:4C'; // use nrf connect from playstore to find
  //final devId1 = '28:CD:C1:00:04:E2'; // use nrf connect from playstore to find
  final devId2 = '28:CD:C1:00:04:E2'; // use nrf connect from playstore to find
  var status1 = 'maja'.obs;
  var status2 = 'bzyk'.obs;
  var startText = 'Start'.obs;
  var timestampString = 'none'.obs;
  var buttonStatus = '0'.obs;
  bool isStarted = false;
  List<int> packet = [0, 0];

  void sendData(val) async {
    packet[0] = val.toInt();
    await frb1.writeCharacteristicWithoutResponse(tx1, value: packet);
    await frb2.writeCharacteristicWithoutResponse(tx2, value: packet);
    isStarted = !isStarted;
    if (isStarted) {
      startText.value = 'Stop';
    } else {
      startText.value = 'Start';
    }
  }

  void sendTime() async {
    final now = DateTime.now();
    int timestamp = now.millisecondsSinceEpoch; // ~/ 1000;
    var bytes = ByteData(8)..setInt64(0, timestamp);
    List<int> timePacket = bytes.buffer.asUint8List().toList();
    timePacket.insert(0, 0x77);
    await frb1.writeCharacteristicWithoutResponse(tx1, value: timePacket);
    await frb2.writeCharacteristicWithoutResponse(tx2, value: timePacket);
    timestampString.value = timestamp.toString();
  }

  void connect() async {
    status1.value = 'Łączę z mają... ';
    status2.value = 'Łączę z bzykiem... ';
    c1 = frb1.connectToDevice(id: devId1).listen((state) {
      if (state.connectionState == DeviceConnectionState.connected) {
        status1.value = 'Maja OK!';

        tx1 = QualifiedCharacteristic(
            serviceId: Uuid.parse("6e400001-b5a3-f393-e0a9-e50e24dcca9e"),
            characteristicId:
                Uuid.parse("6e400002-b5a3-f393-e0a9-e50e24dcca9e"),
            deviceId: devId1);

        rx1 = QualifiedCharacteristic(
            serviceId: Uuid.parse("6e400001-b5a3-f393-e0a9-e50e24dcca9e"),
            characteristicId:
                Uuid.parse("6e400003-b5a3-f393-e0a9-e50e24dcca9e"),
            deviceId: devId1);

        // frb1.subscribeToCharacteristic(rx).listen((data) {
        //   String temp = utf8.decode(data);
        //   buttonStatus.value = temp;
        // });
      }
    });

    c2 = frb2.connectToDevice(id: devId2).listen((state) {
      if (state.connectionState == DeviceConnectionState.connected) {
        status2.value = 'Bzyk OK!';

        tx2 = QualifiedCharacteristic(
            serviceId: Uuid.parse("6e400001-b5a3-f393-e0a9-e50e24dcca9e"),
            characteristicId:
                Uuid.parse("6e400002-b5a3-f393-e0a9-e50e24dcca9e"),
            deviceId: devId2);

        rx2 = QualifiedCharacteristic(
            serviceId: Uuid.parse("6e400001-b5a3-f393-e0a9-e50e24dcca9e"),
            characteristicId:
                Uuid.parse("6e400003-b5a3-f393-e0a9-e50e24dcca9e"),
            deviceId: devId2);

        // frb1.subscribeToCharacteristic(rx).listen((data) {
        //   String temp = utf8.decode(data);
        //   buttonStatus.value = temp;
        // });
      }
    });
  }
}
