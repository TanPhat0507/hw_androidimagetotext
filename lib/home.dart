import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String result = '';
  File? image;
  final ImagePicker imagePicker = ImagePicker();
  final textRecognizer = TextRecognizer(); // Sử dụng TextRecognizer từ google_mlkit_text_recognition

  @override
  void dispose() {
    textRecognizer.close();
    super.dispose();
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await imagePicker.pickImage(source: source);
    if (pickedFile == null) return;

    setState(() {
      image = File(pickedFile.path);
    });

    await performImageRecognition();
  }

  Future<void> performImageRecognition() async {
    if (image == null) return;

    final inputImage = InputImage.fromFile(image!);
    final RecognizedText visionText = await textRecognizer.processImage(inputImage);

    setState(() {
      result = visionText.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/assets/back.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 70),
            Container(
              height: 280,
              width: 250,
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/assets/note.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                child: Text(
                  result,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset('assets/assets/pin.png', height: 240, width: 240),
                TextButton(
                  onPressed: () => pickImage(ImageSource.gallery),
                  onLongPress: () => pickImage(ImageSource.camera),
                  child: Container(
                    margin: const EdgeInsets.only(top: 25),
                    child: image != null
                        ? Image.file(image!, width: 140, height: 192, fit: BoxFit.fill)
                        : const Icon(Icons.camera_enhance_sharp, size: 100, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
