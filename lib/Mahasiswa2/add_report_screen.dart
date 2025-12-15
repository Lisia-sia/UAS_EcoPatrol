import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project_ecopatrol/models/report_model.dart';
import 'package:project_ecopatrol/providers/report_provider.dart';

class AddReportScreen extends ConsumerStatefulWidget {
  const AddReportScreen({super.key});

  @override
  ConsumerState<AddReportScreen> createState() => _AddReportScreenState();
}

class _AddReportScreenState extends ConsumerState<AddReportScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  File? _image;
  double? _latitude;
  double? _longitude;

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
    });
  }

  Future<void> _submit() async {
    if (_titleController.text.isEmpty ||
        _descController.text.isEmpty ||
        _image == null ||
        _latitude == null ||
        _longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua data!')),
      );
      return;
    }

    final report = ReportModel(
      id: '',
      title: _titleController.text,
      description: _descController.text,
      photoPath: _image!.path,
      latitude: _latitude!,
      longitude: _longitude!,
      status: 'pending',
      createdAt: DateTime.now(),
    );

    await ref.read(reportProvider.notifier).addReport(report);
    Navigator.of(context).pop(); // Kembali ke Dashboard
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laporkan Sampah')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Judul')),
              TextField(controller: _descController, decoration: const InputDecoration(labelText: 'Deskripsi'), maxLines: 3),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _getImage,
                icon: const Icon(Icons.camera),
                label: const Text('Ambil Foto'),
              ),
              if (_image != null) Image.file(_image!, height: 200),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _getCurrentLocation,
                icon: const Icon(Icons.location_on),
                label: const Text('Tag Lokasi Terkini'),
              ),
              if (_latitude != null)
                Text('Lokasi: ${_latitude!.toStringAsFixed(4)}, ${_longitude!.toStringAsFixed(4)}'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Kirim Laporan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}