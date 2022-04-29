import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ml_vision/resultScreen.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Recogination',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String pathOfImage = "blank";
  File? image;
  File? myimagePath;
  String finalText = '';
  bool isLoded = false;
  double height = 0.0;
  double width = 0.0;
  int count = 0;

  @override
  void getImage() async {
    try {
      final ImagePicker _imagepicker = ImagePicker();
      final XFile? image =
          await _imagepicker.pickImage(source: ImageSource.gallery);
      setState(() {
        myimagePath = File(image!.path);
        isLoded = true;
        pathOfImage = image.path.toString();
      });
      File myimage =
          new File(pathOfImage); // Or any other way to get a File instance.
      var decodedImage = await decodeImageFromList(myimage.readAsBytesSync());
      setState(() {
        width = decodedImage.width.toDouble();
        height = decodedImage.height.toDouble();
      });
    } catch (e) {
      setState(() {
        isLoded = false;
      });
    }
  }

  Future getCamera() async {
    try {
      final ImagePicker _imagepicker = ImagePicker();
      final XFile? image =
          await _imagepicker.pickImage(source: ImageSource.camera);
      setState(() {
        myimagePath = File(image!.path);
        isLoded = true;
        pathOfImage = image.path.toString();
      });
      File myimage =
          new File(pathOfImage); // Or any other way to get a File instance.
      var decodedImage = await decodeImageFromList(myimage.readAsBytesSync());
      setState(() {
        width = decodedImage.width.toDouble();
        height = decodedImage.height.toDouble();
      });
    } catch (e) {
      setState(() {
        isLoded = false;
      });
    }
  }

  Future getText(String path) async {
    try {
      final inputImage = InputImage.fromFilePath(path);
      final textDetector = GoogleMlKit.vision.textDetector();

      final RecognisedText _reconizedText =
          await textDetector.processImage(inputImage);
      print(_reconizedText.blocks);
      for (TextBlock block in _reconizedText.blocks) {
        for (TextLine textline in block.lines) {
          for (TextElement textElement in textline.elements) {
            setState(() {
              finalText = finalText + " " + textElement.text;
            });
          }
          finalText = finalText + '\n';
        }
      }
    } catch (e) {
      setState(() {
        finalText = 'Please choose an image';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Text recognition".toUpperCase(),
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.7)),
        ),
        elevation: 0,
        backgroundColor: Color(0xFF4E4895),
      ),
      backgroundColor: Color(0xFF4E4895),
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(children: [
              const SizedBox(
                height: 10,
              ),
              isLoded
                  ? Container(
                      // margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        //     shape: BoxShape.circle,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(14),
                        child: Image.file(
                          myimagePath!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 320, bottom: 320, left: 80, right: 70),
                                child: Card(
                                  margin: EdgeInsets.only(right: 20),
                                  elevation: 5.0,
                                  shadowColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(17.0))),
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: MaterialButton(
                                          height: 50,
                                          minWidth: 100,
                                          onPressed: () {
                                            getImage();
                                            Navigator.pop(context);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.photo_outlined,
                                                size: 30,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'Open Gallery',
                                                style: TextStyle(fontSize: 20),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: MaterialButton(
                                          height: 50,
                                          minWidth: 100,
                                          onPressed: () {
                                            getCamera();
                                            Navigator.pop(context);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.camera_alt_outlined,
                                                size: 30,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'Open Camera',
                                                style: TextStyle(fontSize: 20),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Image.asset(
                            'assets/home.png',
                            height: 300,
                            width: 300,
                          ),
                          Text(
                            "Tap to choose Image",
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14.0))),
                onPressed: () async {
                  await getText(pathOfImage);
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => resultScreen(
                          ans: finalText,
                          count: count,
                          isLoaded: isLoded,
                        ),
                      ));
                  setState(() {
                    finalText = '';
                    isLoded = false;
                  });
                },
                height: 47,
                minWidth: 200,
                child: Text(
                  'Get Text',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70),
                ),
                color: Color(0xFF918BCB),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
