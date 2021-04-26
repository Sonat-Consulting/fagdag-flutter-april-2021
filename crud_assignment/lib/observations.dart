import 'package:http/http.dart' as http;
import 'dart:convert';
import 'model.dart';

final host = "localhost:8082"; //Web
//final host = "10.0.2.2:8082"; //Android network


final base = "observations";

Future<http.Response> deleteObservation(int id) async {
  final http.Response response = await http.delete(
    Uri.http(host, '$base/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  return response;
}


Future<Observation> createObservation(Observation obs) async {
  final response = await http.post(
    Uri.http(host, base),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'userId': obs.userId,
      'title': obs.title,
      'description' : obs.description ?? ""
    }),
  );
  if (response.statusCode == 201) {
    return Observation.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create observation $obs due to ${response.statusCode}');
  }
}


Future<Observation> updateObservation(Observation obs) async {
  final int id = obs.id!; //Ensure fail early if non null
  final response = await http.put(
    Uri.http(host, '$base/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'userId': obs.userId,
      'title': obs.title,
      'description' : obs.description ?? ""
    }),
  );
  if (response.statusCode == 200) {
    return Observation.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create observation $obs due to ${response.statusCode}');
  }
}



Future<Observation> getObservation(int id) async {
  final response = await http.get(Uri.http(host, '$base/$id'));
  if (response.statusCode == 200) {
    return Observation.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to retrieve observation with id: $id due to ${response.statusCode}');
  }
}



Future<List<Observation>> listObservations() async {
  final response = await http.get(Uri.http(host, base));
  if (response.statusCode == 200) {
    final List<dynamic> array = jsonDecode(response.body);
    return array
        .map((e) => Observation.fromJson(e))
        .toList();
  } else if (response.statusCode == 404) {
    return [];
  }
  else {
    throw Exception('Failed list observations due to ${response.statusCode}');
  }
}