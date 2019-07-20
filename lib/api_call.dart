import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


const URL = "https://radio.ahlsunnah.dev";
Future fetchStations() async {
  final response =
  await http.get(URL + '/stations/');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return response;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load stations');
  }
}


