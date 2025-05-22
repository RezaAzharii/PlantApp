import 'dart:io';
import 'package:flutter/material.dart';
import 'package:plantapp/constants.dart';
import 'package:plantapp/screens/maps/maps_screen.dart';
import 'package:plantapp/camera/camera.dart';
import 'package:plantapp/screens/profiles/storage_helper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final File? profileImage;
  final String? initialAddress;

  const ProfileScreen({super.key, this.profileImage, this.initialAddress});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _imageProfile;
  String? _alamatDipilih;
  final TextEditingController _provinsiController = TextEditingController();
  final TextEditingController _kodePosController = TextEditingController();

  void _extractAddressComponents() {
    if (_alamatDipilih != null) {
      final addressParts = _alamatDipilih!.split(',');
      if (addressParts.length > 3) {
        _provinsiController.text = addressParts[addressParts.length - 3].trim();
        _kodePosController.text = addressParts[addressParts.length - 2].trim();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        
      ),
    );
  }
}