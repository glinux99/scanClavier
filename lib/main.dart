import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int count =0;
  List <Map<String, dynamic>> liste =[{}];
  String result = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("VE COMPTEUR SCAN", style: TextStyle(color: Colors.white)),backgroundColor: Color.fromARGB(221, 238, 133, 5),),
      body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Barcode: $result'),
          const Text("-----------------------------------------------------"),
          ListView.builder(itemBuilder: (context, i){
            Map _data = liste[i];
            return ListTile(
              leading: Icon(Icons.keyboard),
              title: Text("Compteur ${_data['compteur']}"),
              subtitle: Text("Clavier ${_data['clavier']}"),
            );
          })
        ],
      ),
    )
,
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
                    count ++;
                    if(result!='-1'){
                      Map <String, dynamic> scan ={
                        
                      };
                      if(count ==1){
                       scan[ "clavier"]= result;
                      }
                      if(count==2){
                        scan['compteur'] = result;
                        liste.add(scan);
                      }
                      // liste.add(result);
                    }else{
                      
                    }
                  }
                });
              },
        tooltip: 'add',
        child: const Icon(Icons.qr_code_2),
      ), 
    );
  }
}