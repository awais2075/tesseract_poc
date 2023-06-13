import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const OCRDemo(title: 'Flutter Tesseract OCR POC'),
    );
  }
}


class OCRDemo extends StatefulWidget {
  const OCRDemo({super.key, required this.title});

  final String title;

  @override
  State<OCRDemo> createState() => _OCRDemoState();
}

class _OCRDemoState extends State<OCRDemo> {

  String ocrText = '';
  final String imageName = 'pus_bw.jpeg';
  final String imagePath = 'assets/images';
  final String language = 'pus';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(children: <Widget>[
          Image.asset('$imagePath/$imageName', width: 200, height: 200,),
          ElevatedButton(onPressed: () => {
            _fetchTextFromImage(
                imagePath: imagePath, imageName: imageName, language: language)
          }, child: const Text('Process')),
          Text(ocrText, style: const TextStyle(color: Colors.lightGreen),)
        ]),
      ),
    );
  }

  _fetchTextFromImage({required String imagePath, required imageName, required String language}) async {
    var processFile = await rootBundle.load('$imagePath/$imageName');
    var tempDir = await getTemporaryDirectory();
    var file = File('${tempDir.path}/$imageName');
    file.writeAsBytes(processFile.buffer.asUint8List());

    String dir = await FlutterTesseractOcr.getTessdataPath();

    FlutterTesseractOcr.extractText(file.path, language: language)
        .then((value) {
      setState(() {
        ocrText = value;
      });
    }).catchError((error) {
      setState(() {
        print('error');
        ocrText = error.message;
      });
    });
  }
}

