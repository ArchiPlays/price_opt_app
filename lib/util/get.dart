import 'dart:convert';

import 'package:http/http.dart';
import 'package:optiprice_ai/util/constants.dart';
import 'package:optiprice_ai/util/data_object.dart';

Future<List<Map<String, dynamic>>> getDatasets() async {
  final response = await get(Uri.parse('$apiUrl/available_datasets'));
  try {
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load datasets');
    }
  } catch (e) {
    throw Exception('Failed to load datasets');
  }
}

Future<List<String>> getProducts(String dataset) async {
  final response = await get(Uri.parse('$apiUrl/list_products/$dataset'));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => e.toString()).toList();
  } else {
    throw Exception('Failed to load products');
  }
}

Future<Map<String, dynamic>> getResults(
    String product, String field, String value, String dataset) async {
  final response =
      await get(Uri.parse('$apiUrl/$product/$field/$value?dataset=$dataset'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body) as Map<String, dynamic>;
  } else {
    throw Exception('Failed to load results');
  }
}

Future<List<DataObject>> getTableData(String product, String dataset) async {
  final response =
      await get(Uri.parse('$apiUrl/product_history/$product?dataset=$dataset'));
  try {
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((e) => DataObject.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      return [];
    }
  } catch (e) {
    throw Exception('Failed to load table data');
  }
}
