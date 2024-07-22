import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

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

Future<void> writeExcelToExternalStorage(
    List<Map<String, dynamic>> data) async {
  // Request storage permission

  if (!await Permission.storage.request().isGranted) {
    // Create an Excel workbook
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    // Populate the sheet with data
    // ... (your data population logic)

    // Get external storage directory
    final directory = await getExternalStorageDirectory();
    if (directory != null) {
      final file = File('/storage/emulated/0/Download/my_excel_file.xlsx');
      // Write the Excel file to external storageint i = 1;
      int i = 1;
      // Create the file if it doesn't exist
      if (!await file.exists()) {
        await file.create(recursive: true);
      } else {
        var bytes = file.readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);
        Sheet sheetObject = excel['claviers et compteurs'];

        // Count the number of elements (assuming data starts from row 2)
        int lastRow = sheetObject.maxRows;
        print("XXXXXXXXXXXXXX $lastRow");
        // int elementCount =
        //     lastRow > 1 ? lastRow - 1 : 0; // Subtract 1 to exclude header row

        // // Initialize index based on element count (start from next row)
        // i = elementCount + 1;
      }
      Sheet sheetObject = excel['claviers et compteurs'];

      for (var element in data) {
        var cell = sheetObject.cell(CellIndex.indexByString('A$i'));
        var cellb = sheetObject.cell(CellIndex.indexByString('B$i'));
        cell.value = TextCellValue(element['compteur']);
        cellb.value = TextCellValue(element['clavier']);
        i++;
      }
      // Write the Excel data to the file
      await file.writeAsBytes(excel.save() ?? [0]);

      print('Excel file saved to: ${file.path}');
    } else {
      print('External storage not available');
    }
  } else {
    print('Storage permission denied');
  }
}

class _HomePageState extends State<HomePage> {
  int count = 0;
  Map<String, dynamic> scan = {};
  List<Map<String, dynamic>> liste = [];
  String result = '';
  // automatically creates 1 empty sheet: Sheet1
  var excel = Excel.createExcel();
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
                  // excelX();
                  print(liste);
                  writeExcelToExternalStorage(liste);
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
