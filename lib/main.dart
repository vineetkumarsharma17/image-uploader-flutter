import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State
{
ImagePicker picker=new ImagePicker();
  final nameController = TextEditingController();
  //File file;
  var serverReceiverPath = "https://indianfarmerbyvkwilson.000webhostapp.com/regisemp.php";

  Future<void> uploadImage(filename) async {

    var request = http.MultipartRequest('POST', Uri.parse(serverReceiverPath));

    request.files.add(await http.MultipartFile.fromPath('image', filename));

    request.fields["name"]=nameController.text;

    var res = await request.send();

    if(res.statusCode == 200){
      print(res);

    }else{
      print("Error during connection to server");
    }
  }


  XFile uploadimage; //variable for choosed file

  Future<void> chooseImage() async {

    XFile choosedimage = await picker.pickImage(source: ImageSource.gallery);
    //set source: ImageSource.camera to get image from camera
    setState(() {
      uploadimage = choosedimage;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Image to Server"),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body:SafeArea(child:SingleChildScrollView(child: Container(  padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center, //content alignment to center
          children: <Widget>[
            Container(
                child:TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: 'Enter your full name',
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "success",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 4,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );   // return 'Please enter some text';
                    }
                    return null;
                  },
                )
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              //show image here after choosing image
              child:uploadimage == null?
              Container(): //if uploadimage is null then show empty container
              SingleChildScrollView(child:Container(
                //padding: EdgeInsets.all(10.0),  //elese show image here
                  child: SizedBox(
                      height:150,
                      child:Image.file(File(uploadimage.path)) //load image from file
                  )
              )
              ),
            ),
            Container(
              //show upload button after choosing image
                child:uploadimage == null?
                Container(
                ): //if uploadimage is null then show empty container
                Container(   //elese show uplaod button
                    child:RaisedButton.icon(
                      onPressed: (){
                        uploadImage(uploadimage.path);
                      },
                      icon: Icon(Icons.file_upload),
                      label: Text("UPLOAD IMAGE"),
                      color: Colors.deepOrangeAccent,
                      colorBrightness: Brightness.dark,
                      //set brghtness to dark, because deepOrangeAccent is darker coler
                      //so that its text color is light
                    )
                )
            ),
            Container(padding: EdgeInsets.all(10.0),
              child: RaisedButton.icon(
                onPressed: (){
                  chooseImage(); // call choose image function
                },
                icon:Icon(Icons.folder_open),
                label: Text("CHOOSE IMAGE"),
                color: Colors.deepOrangeAccent,
                colorBrightness: Brightness.dark,
              ),
            )
          ],),
      ),
      ), ), );
  }
}