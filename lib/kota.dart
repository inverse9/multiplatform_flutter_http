import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'kecamatan.dart';

class Kota extends StatelessWidget {
  final Map<String, dynamic> province;

  Kota(this.province);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(province["name"]),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: KotaBody(province["id"]));
  }
}

class KotaBody extends StatelessWidget {
  final String provinceId;

  KotaBody(this.provinceId);
  @override
  Widget build(BuildContext context) {
    final apiUrl = Uri.parse(
        "https://api.goapi.io/regional/kota?provinsi_id=${provinceId}&api_key=563d00a1-fb80-5584-1d0d-8829ba4d");

    Future<List<dynamic>> fetchData() async {
      final response = await http.get(apiUrl);
      if (response.statusCode == 200) {
        return jsonDecode(response.body)["data"];
      } else {
        throw Exception('Failed to load data');
      }
    }

    return FutureBuilder(
      future: fetchData(),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final item = snapshot.data![index];
              final subdistrict = snapshot.data![index];

              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Kecamatan(subdistrict),
                    ),
                  );
                },
                title: Text(item["name"]),
              );
            },
          );
        }
      },
    );
  }
}
