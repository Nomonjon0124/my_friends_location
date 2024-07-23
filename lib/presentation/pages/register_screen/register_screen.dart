import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_friends_location/data/local/shared_pref_helper.dart';
import 'package:my_friends_location/presentation/pages/friends_screen/friends_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  Uint8List? _image;
  File? selectedImage;
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    _getUserLocation();
    super.initState();
  }

  Future<void> _getUserLocation() async {
    final status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
      //final position = await Geolocator.getCurrentPosition();
      _latitude= await Geolocator.getCurrentPosition().then((value)=>value.latitude);
      _longitude= await Geolocator.getCurrentPosition().then((value)=>value.longitude);

    } else {
      print('Location permission denied');
    }
  }

  Future<void> _saveData() async {
    if (_image == null || nameController.text.isEmpty) {
      print('All fields are required');
      return;
    }
    try{
      // Rasimni Firebase Storage-ga yuklash
      Reference storageReference = FirebaseStorage.instance.ref().child('images/${DateTime.now().millisecondsSinceEpoch}');
      UploadTask uploadTask = storageReference.putData(_image!);
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();
      // Ma'lumotlarni Firebase Firestore-ga saqlash
      await FirebaseFirestore.instance.collection('users1').add({
        'name': nameController.text,
        'image': imageUrl,
        'latitude':_latitude,
        'longitude':_longitude
      });
    }catch(e){
      print('Error saving data: $e');
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Center(
              child: Stack(
                children: [
                  _image == null
                      ? const CircleAvatar(
                          radius: 80,
                          backgroundImage: NetworkImage("https://giveawork.com/assets/backend/images/users/avatar-1.png"),
                        )
                      : CircleAvatar(
                          radius: 80,
                          backgroundImage: MemoryImage(_image!),
                        ),
                  Positioned(
                      bottom: -10,
                      child: IconButton(
                          onPressed: () {
                            showImagePickerOption(context);
                          },
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: Colors.white,
                            size: 32,
                          )))
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 68,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey, width: 1.0)),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: TextField(
                  style:  TextStyle(fontSize: 20, color: Theme.of(context).textTheme.bodyLarge?.color),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 20),
                    hintText: 'Ismingizni kiriting',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                  controller: nameController,
                ),
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: (){
              _saveData();
              //uploadImageToFirebase(selectedImage);
              SharedPrefHelper.setLoggedIn(true);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const FriendsScreen()));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              padding: const EdgeInsets.symmetric(vertical: 15),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).colorScheme.primary),
              child: Center(
                child: Text(
                  "Keyingi",
                  style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 7,
              color: Theme.of(context).colorScheme.background,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        pickImageFromGallery();
                      },
                      child: SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.photo_camera_back_outlined,
                              size: 48,
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                            Text(
                              "Gallery",
                              style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 24.0, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _pickImageFromCamera();
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            size: 48,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                          Text(
                            "Camera",
                            style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 24.0, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future pickImageFromGallery() async {
    final returnImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    setState(() {
      selectedImage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });

    Navigator.of(context).pop();
  }

  Future _pickImageFromCamera() async {
    final returnImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return;
    if(mounted){
      setState(() {
        selectedImage = File(returnImage.path);
        _image = File(returnImage.path).readAsBytesSync();
      });
    }
    Navigator.of(context).pop();
  }
}
