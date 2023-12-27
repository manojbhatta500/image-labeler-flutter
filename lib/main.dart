import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;

  late ImagePicker imagePicker;

  String result = 'Results will be shown here';
  late ImageLabeler imageLabeler;

  void chooseImage() async {
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
        doImagelabel();
      });
    }
  }

  void captureImage() async {
    print('pressed capture button');
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      print('entering set state ');
      setState(() {
        print('entering set state ');
        _image = File(image.path);
        print('set state done ');
        doImagelabel();
      });
    }
    print('capture image done  ');
  }

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    final ImageLabelerOptions options =
        ImageLabelerOptions(confidenceThreshold: 0.5);
    imageLabeler = ImageLabeler(options: options);
  }

  doImagelabel() async {
    InputImage inputImage = InputImage.fromFile(_image!);
    final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
    result = '';

    for (ImageLabel label in labels) {
      final String text = label.label;
      final int index = label.index;
      final double confidence = label.confidence;
      result += '$text  ' + confidence.toStringAsFixed(2) + '%' '\n';
    }
    setState(() {
      result;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.greenAccent,
            title: Text(
              'Image label',
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
          ),
          endDrawer: Drawer(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                      child: Text(
                    'Made By Manoj Bhatta',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  )),
                  Center(
                      child: Text(
                    'powered by google mlkit image labeling',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  )),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
          body: Container(
            height: height,
            width: width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/bg.jpg'), fit: BoxFit.cover),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  _image != null
                      ? Padding(
                          padding: const EdgeInsets.all(20),
                          child: Image.file(
                            _image!,
                            height: 0.3 * height,
                          ),
                        )
                      : const Icon(
                          Icons.image,
                          size: 100,
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      chooseImage();
                    },
                    child: Container(
                      width: 0.6 * width,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Color(0xfff9c520)),
                      child: Center(
                        child: Text("Choose",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      captureImage();
                    },
                    child: Container(
                      width: 0.6 * width,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Color(0xfff9c520)),
                      child: Center(
                        child: Text("Capture",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                      child: Text(
                    result,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
