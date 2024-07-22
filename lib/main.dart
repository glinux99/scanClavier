import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VE Compte',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int count = 0;
  Map<String, dynamic> scan = {};
  List<Map<String, dynamic>> liste = [{}];
  String result = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("VE COMPTEUR SCAN",
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(221, 238, 133, 5),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: liste.length,
          itemBuilder: (context, i) {
            Map data = liste[i];
            return ListTile(
              leading: const Icon(Icons.keyboard),
              title: Text("Compteur ${data['compteur']}"),
              subtitle: Text("Clavier ${data['clavier']}"),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var res = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SimpleBarcodeScannerPage(),
              ));
          setState(() {
            if (res is String) {
              result = res;
              count++;
              print(count);

              if (result != '-1') {
                if (count == 1) {
                  scan["clavier"] = result;
                }
                if (count == 2) {
                  scan['compteur'] = result;
                  liste.add(scan);
                  print(scan);
                  count = 0;
                  scan = {};
                }
                // liouste.add(result);
              } else {}
            }
          });
        },
        tooltip: 'add',
        child: const Icon(Icons.qr_code_2),
      ),
    );
  }
}
