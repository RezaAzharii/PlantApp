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

  Future<void> _requestPermission() async {
    await Permission.camera.request();
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
  }

  Future<void> _takePicture() async {
    await _requestPermission();
    final File? result = await Navigator.push<File?>(
      context,
      MaterialPageRoute(builder: (_) => const CameraPage()),
    );
    if (result != null) {
      final saved = await StorageHelper.saveImage(result, 'camera');
      setState(() => _imageProfile = saved);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto profil berhasil diubah')),
      );
    }
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final saved = await StorageHelper.saveImage(File(picked.path), 'gallery');
      setState(() => _imageProfile = saved);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto profil berhasil diubah')),
      );
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera, color: kPrimaryColor),
                title: const Text('Ambil Foto dari Kamera'),
                onTap: () {
                  Navigator.pop(context);
                  _takePicture();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: kPrimaryColor),
                title: const Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveProfile() {
    if (_imageProfile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap pilih foto profil terlebih dahulu'),
        ),
      );
      return;
    }

    Navigator.pop(context, {
      'image': _imageProfile,
      'address': _alamatDipilih,
      'province': _provinsiController.text,
      'postalCode': _kodePosController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile', style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: kPrimaryColor,
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              color: Colors.white,
              onPressed: _saveProfile,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _showImagePickerOptions,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300],
                      backgroundImage:
                          _imageProfile != null
                              ? FileImage(_imageProfile!)
                              : null,
                      child:
                          _imageProfile == null
                              ? Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.grey[600],
                              )
                              : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Text(
                "Reza Azhari",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                "rezaazhari809@gmail.com",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 4),
              Text(
                "+62 812-3456-7890",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 32),

              _buildAddressSection(),
              const SizedBox(height: 16),
              _buildProvinceAndPostalCode(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Alamat',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MapsPage()),
            );
            if (result != null) {
              setState(() {
                _alamatDipilih = result;
                _extractAddressComponents();
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, color: kPrimaryColor),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    _alamatDipilih ?? 'Tap untuk memilih alamat',
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          _alamatDipilih != null ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProvinceAndPostalCode() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Provinsi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              AbsorbPointer(
                child: TextFormField(
                  controller: _provinsiController,
                  decoration: InputDecoration(
                    hintText: "Provinsi",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Kode Pos',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              AbsorbPointer(
                child: TextFormField(
                  controller: _kodePosController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Kode pos",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _provinsiController.dispose();
    _kodePosController.dispose();
    super.dispose();
  }
}
