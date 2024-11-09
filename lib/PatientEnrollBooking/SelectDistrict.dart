import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DistrictDropdown extends StatefulWidget {
  final String bearerToken; // Accepts bearer token as parameter
  const DistrictDropdown({required this.bearerToken, Key? key})
      : super(key: key);

  @override
  _DistrictDropdownState createState() => _DistrictDropdownState();
}

class _DistrictDropdownState extends State<DistrictDropdown> {
  List<District> _districts = [];
  District? _selectedDistrict;

  @override
  void initState() {
    super.initState();
    _fetchDistricts();
  }

  Future<void> _fetchDistricts() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://104.237.9.211:8007/karuthal/api/v1/metadata/districts'),
        headers: {
          'Authorization':
              'Bearer ${widget.bearerToken}', // Uses token from Patientenroll
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> result = jsonResponse['result'];

        setState(() {
          _districts =
              result.map((district) => District.fromJson(district)).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to load districts: ${response.body}'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error occurred: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<District>(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      value: _selectedDistrict,
      hint: Text('Select a district'),
      items: _districts.map((district) {
        return DropdownMenuItem<District>(
          value: district,
          child: Text(district.name),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedDistrict = newValue;
        });
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          // borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xFFEBBBED)),
        ),
      ),
    );
  }
}

class District {
  final int id;
  final String name;

  District({required this.id, required this.name});

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['id'],
      name: json['name'],
    );
  }
}
