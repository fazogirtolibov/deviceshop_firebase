import 'package:default_project/data/services/file_uploader.dart';
import 'package:default_project/ui/admin/admin_screen.dart';
import 'package:default_project/utils/color.dart';
import 'package:default_project/utils/icon.dart';
import 'package:default_project/view_models/profile_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  String imageUrl = "";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: GoogleFonts.raleway(
            color: MyColors.appBarText,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            child: Text(
              "Log Out",
              style: GoogleFonts.raleway(
                color: MyColors.appBarText,
              ),
            ),
          ),
        ],
      ),
      body: Consumer<ProfileViewModel>(
        builder: (context, profileViewModel, child) {
          return profileViewModel.user != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(profileViewModel.user!.email.toString()),
                    Text(profileViewModel.user!.uid.toString()),
                    Text(profileViewModel.user!.displayName.toString()),
                    isLoading
                        ? const CircularProgressIndicator()
                        : const SizedBox(),
                    Container(
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      width: 100,
                      height: 100,
                      child: profileViewModel.user!.photoURL == null
                          ? Image.asset(
                              MyIcons.imageSample,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              profileViewModel.user!.photoURL!,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.height * 0.15,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xff2A2A2A),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Add to basket",
                            style: GoogleFonts.raleway(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text("Gallery"),
                    onTap: () {
                      _getFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    _getFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  _getFromGallery() async {
    XFile? pickedFile = await _picker.pickImage(
      maxWidth: 1000,
      maxHeight: 1000,
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      if (!mounted) return;
      setState(() {
        isLoading = true;
      });
      if (!mounted) return;
      imageUrl = await FileUploader.imageUploader(pickedFile);
      if (!mounted) return;
      Provider.of<ProfileViewModel>(context, listen: false)
          .updatePhoto(imageUrl);
      setState(() {
        isLoading = false;
        _image = pickedFile;
      });
    }
  }

  _getFromCamera() async {
    XFile? pickedFile = await _picker.pickImage(
      maxWidth: 1920,
      maxHeight: 2000,
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      if (!mounted) return;
      imageUrl = await FileUploader.imageUploader(pickedFile);
      if (!mounted) return;
      Provider.of<ProfileViewModel>(context, listen: false)
          .updatePhoto(imageUrl);
      setState(() {
        _image = pickedFile;
      });
    }
  }
}
