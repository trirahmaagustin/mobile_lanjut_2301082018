import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpStateful {
  String? id, name, job, createAt;

  HttpStateful({
    this.id,
    this.name,
    this.job,
    this.createAt,
  });

  static Future<HttpStateful> connectAPI(String name, String job) async {
    Uri URL = Uri.parse("https://reqres.in/api/users");

    var hasilResponse = await http.post(
      URL,
      body: {
        "name": name,
        "job": job,
      },
    );

    var data = json.decode(hasilResponse.body);

    return HttpStateful(
      id: data['id'].toString(),
      name: data['name'].toString(),
      job: data['job'].toString(),
      createAt: data['createdAt'].toString(), // Corrected field name
    );
  }
}