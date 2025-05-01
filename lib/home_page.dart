import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;

  @override
  void initState() {
    super.initState();
    getDevices();
  }

  void getDevices() async {
    devices = await printer.getBondedDevices();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<BluetoothDevice>(
              padding: const EdgeInsets.only(left: 20, right: 20),
              isExpanded: true,
              value: selectedDevice,
              hint: const Text('Select a device...'),
              items: devices
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e.name!,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                  .toList(),
                  
              onChanged: (devices) {
                setState(() {
                  selectedDevice = devices;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                printer.connect(selectedDevice!);
              },
              child: const Text('Connect'),
            ),
            ElevatedButton(
              onPressed: () {
                printer.disconnect();
              },
              child: const Text('Disconnect'),
            ),
            ElevatedButton(
              onPressed: () async {
                if ((await printer.isConnected)!) {
                  printer.printNewLine();
                  printer.printCustom('Hello World', 2, 1);
                  printer.printNewLine();
                  printer.printQRcode('IAL23100030', 250, 250, 1);
                  printer.printCustom('IAL23100030', 2, 1);
                  printer.printNewLine();
                  printer.printNewLine();
                  printer.printNewLine();
                  printer.printNewLine();
                }
              },
              child: const Text('Print'),
            ),
          ],
        ),
      ),
    );
  }
}
