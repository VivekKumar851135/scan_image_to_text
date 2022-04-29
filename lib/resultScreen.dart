import 'package:flutter/material.dart';

class resultScreen extends StatefulWidget {
  resultScreen({
    // Key? key,
    required this.ans,
    required this.count,
    required this.isLoaded,
  });
  //: super(key: key);
  String ans = '';
  String pyans = '';
  int count = 0;
  bool isLoaded = false;

  @override
  _resultScreenState createState() => _resultScreenState();
}

class _resultScreenState extends State<resultScreen> {
  void initState() {
    super.initState();
    if (widget.isLoaded == false) {
      widget.ans = 'Please choose a image';
    }
    if (widget.ans.isEmpty) {
      widget.ans = 'No text found in image';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4E4895),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF4E4895),
        centerTitle: true,
        title: Text(
          "Copy your Text".toUpperCase(),
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.7)),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(
                context,
              );
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SelectableText(
            widget.ans != null ? widget.ans : 'No text on image',
            textAlign: TextAlign.center,
            showCursor: true,
            cursorWidth: 2,
            cursorColor: Colors.red,
            cursorRadius: Radius.circular(5),
            style: TextStyle(
              fontSize: 30,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
