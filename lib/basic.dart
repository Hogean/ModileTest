import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:modbus/modbus.dart' as modbus;
import 'package:modbus/modbus.dart';

class BasicPage extends StatefulWidget {
  @override
  _BasicPageState createState() => _BasicPageState();
}

class _BasicPageState extends State<BasicPage> {
  final myController = TextEditingController();

  static ModbusClient? cli;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Basic Commands to Control and Monitor Motor"),
                TextButton(onPressed: _sendFL, child: Text('Feed to Length')),
                TextButton(
                    onPressed: _emergencyStop,
                    child: Text(
                      'Emergency Stop',
                      style: TextStyle(color: Colors.red),
                    )
                ),
                ReadMotor()
              ],
            )),
      ),
    );
  }

  static void _connect() async {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      print(
          '${rec.level.name}: ${rec.time} [${rec.loggerName}]: ${rec.message}');
    });

    var client = modbus.createTcpClient(
      '10.10.10.11',
      port: 502,
      mode: modbus.ModbusMode.rtu,
    );

    //await
    await client.connect();
    cli = client;
  }

  void _sendFL() async {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      print(
          '${rec.level.name}: ${rec.time} [${rec.loggerName}]: ${rec.message}');
    });

    var client = modbus.createTcpClient(
      '10.10.10.11',
      port: 502,
      mode: modbus.ModbusMode.rtu,
    );

    //await
    await client.connect();

    client.writeSingleRegister(124, 102);
    //TODO: why 124
  }

  void _emergencyStop() {
    _connect();
    cli?.writeSingleRegister(124, 225);
  }

  void _readSpeed() {}
}

class ReadMotor extends StatefulWidget {
  @override
  _ReadMotorState createState() => _ReadMotorState();
}

class _ReadMotorState extends State<ReadMotor> {
  ModbusClient? cli;
  int speed = 1;

  void _connect() async {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      print(
          '${rec.level.name}: ${rec.time} [${rec.loggerName}]: ${rec.message}');
    });

    var client = modbus.createTcpClient(
      '10.10.10.11',
      port: 502,
      mode: modbus.ModbusMode.rtu,
    );

    //await
    await client.connect();
    cli = client;
  }

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('immediate speed: $speed'),
        TextButton(onPressed: _refresh, child: Text('read'))
      ],
    );
  }

  void _refresh() async {
    _connect();
    var speed_now;
    speed_now = await cli?.readInputRegisters(10, 1);
    speed_now.toString();

    setState(() {
      speed = speed_now;
    });
  }
}
