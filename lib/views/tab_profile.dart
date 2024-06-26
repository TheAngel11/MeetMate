import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meet_mate/views/login.dart';
import 'package:meet_mate/views/main.dart';
import '../components/buttons.dart';
import '../components/text_fields.dart';
import '../utils/utils.dart';


class TabProfileView extends StatefulWidget {
  final String uid;
  final bool editProfileMode;
  const TabProfileView({Key? key, required this.uid, required this.editProfileMode}) : super(key: key);

  @override
  _TabProfileViewState createState() => _TabProfileViewState(uid: uid, editProfileMode: editProfileMode);

}

class _TabProfileViewState extends State<TabProfileView> {
  final String uid;
  Image profileImage = Image.asset('assets/images/default_profile_image.png', height: 200, width: 200);
  File? profileImageFile;
  String name = 'Name';
  String age = 'Age';
  var interestsField = TextEditingController();
  var aboutMeField = TextEditingController();
  String edit = 'Edit';
  String signOutText = 'Sign Out';
  bool editable = false;
  var formKey = GlobalKey<FormState>();
  final bool editProfileMode; //If this is true, we will not show the appbar and we will show the buttons to edit and sign out

  _TabProfileViewState({required this.uid, required this.editProfileMode});

  @override
  void initState() {
    super.initState();
    getProfileInfo();
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !editProfileMode ?
      AppBar(
        title: const Text('View Profile'),
        centerTitle: true,
        backgroundColor: const Color(0xffe87e70),
      ) : null,
      backgroundColor: const Color(0xffe87e70),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 64),
              CircleAvatar(
                radius: 100,
                backgroundImage: profileImage.image,
              ),
              const SizedBox(height: 12),
              if (editable)
                ImageButton(
                  onPressed: () {
                    if (!editable) {
                      return;
                    }
                    pickImageClicked();
                  },
                ),
                const SizedBox(height: 16),

              Text('$name - $age', style:
              const TextStyle(fontSize: 24, fontWeight: FontWeight.bold,
                  color: Colors.white)),

              const SizedBox(height: 16),
              EditingTextField(
                labelText: 'Interests',
                enabled: editable,
                controller: interestsField,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your interests';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              EditingTextField(
                labelText: 'About Me',
                enabled: editable,
                controller: aboutMeField,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter something about yourself';
                  }
                  return null;
                },
                isMultiline: true,
              ),
              const SizedBox(height:32),
              if (editProfileMode)
                MainButton(
                  onPressed: () {
                    if (editable && formKey.currentState!.validate()) {
                      saveProfileInfo();
                    }
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        editable = !editable;
                        if (editable) {
                          edit = 'Save';
                        } else {
                          edit = 'Edit';
                        }
                      });
                    }
                  },
                  text: edit,
                ),
                if (editProfileMode)
                MainButton(
                  onPressed: () {
                    signOut();
                  },
                  text: signOutText,
                )

            ],
          ),
        ),

      ),
    );
  }

  void saveProfileInfo() async {
    FirebaseFirestore.instance.collection('users').doc(uid).update({
      'interests': interestsField.text,
      'about_me': aboutMeField.text,
    }).then((value) {
      setState(() {
        editable = false;
        edit = 'Edit';
      });
    });

    FirebaseStorage.instance.ref('profile_images/$uid').putFile(File(profileImageFile!.path));

  }



  void getProfileInfo() async {
    FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) {
      setState(() {
        name = value.get('name');
        var birthdate = value.get('birthdate');
        age = (DateTime.now().difference(DateTime.parse(birthdate)).inDays / 365).floor().toString();
        interestsField.text = value.get('interests');
        aboutMeField.text = value.get('about_me');
      });
    });

    FirebaseStorage.instance.ref().child('profile_images/$uid').getDownloadURL().then((value) {
      setState(() {
        profileImage = Image.network(value, height: 200, width: 200);
      });
    });
  }


  void pickImageClicked() async {
    final pickedImage = await Utils.pickImage(context);
    if (pickedImage != null) {
      setState(() {
        profileImageFile = File(pickedImage.path);
        profileImage = Image.file(profileImageFile!, height: 200, width: 200);
      });
    }
  }
}