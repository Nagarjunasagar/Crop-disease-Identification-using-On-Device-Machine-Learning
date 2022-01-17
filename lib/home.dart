// ignore_for_file: non_constant_identifier_names, deprecated_member_use, sized_box_for_whitespace, avoid_unnecessary_containers, unnecessary_null_comparison, prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = true;
  late File _image;
  late List _output;
  final imagepicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadmodel().then((value) {
      setState(() {});
    });
  }

  detectimage(File image) async {
    var prediction = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.6,
        imageMean: 127.5,
        imageStd: 127.5);

    setState(() {
      _output = prediction!;
      loading = false;
    });
  }

  loadmodel() async {
    await Tflite.loadModel(
        model: 'assets/model_unquant.tflite', labels: 'assets/labels.txt');
  }

  @override
  void dispose() {
    super.dispose();
  }

  pickimage_camera() async {
    var image = await imagepicker.getImage(source: ImageSource.camera);
    if (image == null) {
      return null;
    } else {
      _image = File(image.path);
    }
    detectimage(_image);
  }

  pickimage_gallery() async {
    var image = await imagepicker.getImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    } else {
      _image = File(image.path);
    }
    detectimage(_image);
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        backgroundColor:nPrimarycolor ,
        centerTitle: true,
        title: Text(
          
          'CRO HEAL',
          style: GoogleFonts.roboto(fontSize: 24, fontWeight:FontWeight.bold),
        ),
      ),
      body: Container(
        height: h,
        width: w,
        child: Column(
          children: [
            Container(
              height: 150,
              width: 150,
              padding: const EdgeInsets.all(10),
              //child: Image.asset('assets/images/leaves.png'),
            ),
            Text('Crop Disease Identifier',
                style: GoogleFonts.roboto(
                  color: Color(0xFF002222),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 50),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  height: 50,
                  width: double.infinity,
                  child: RaisedButton(
                      color: nPrimarycolor,
                      textColor: nTextcolor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Text('Capture',
                          style: GoogleFonts.roboto(fontSize: 20, fontWeight:FontWeight.bold)),
                      onPressed: () {
                        pickimage_camera();
                      }),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  height: 50,
                  width: double.infinity,
                  child: RaisedButton(
                      
                      textColor: nTextcolor,
                      //textTheme: 
                      color: nPrimarycolor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Text('Gallery',
                          style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold)),
                          
                      onPressed: () {
                        pickimage_gallery();
                      }),
                ),
              ],
            ),
            loading != true
                ? Container(
                    child: Column(
                      children: [
                        Container(
                          height: 220,
                          // width: double.infinity,
                          padding: EdgeInsets.all(15),
                          child: Image.file(_image),
                        ),
                        _output != null
                            ? Text(
                              'Disease Predicted as : ' +

                                (_output[0]['label']).toString().substring(2),
                                style: GoogleFonts.roboto(fontSize: 18, 
                                                          fontWeight:FontWeight.bold,
                                                          color: Color(0xFF002222),))
                            : Text(''),
                        _output != null
                            ? Text(
                                'Prediction Accuracy of : ' +
                                    (_output[0]['confidence']).toString(),
                                style: GoogleFonts.roboto(fontSize: 14, 
                                                          fontWeight:FontWeight.bold,
                                                          color: Color(0xFF002222),))
                            : Text('')
                      ],
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
