import 'package:http/http.dart' as http;

import '../config.dart';

class UploadService {
  static Future<String> uploadImage(String title, String path) async {
    var url = Config.backendURL + '/v1/images';
    try {
      var request = http.MultipartRequest('PUT', Uri.parse(url));
      request.files.add(
        await http.MultipartFile.fromPath('imageFile', path),
      );
      var res = await request.send();
      var response = await http.Response.fromStream(res);
      print(response.body);
      var id = response.body.substring(1, response.body.length - 2);
      return '/images/$id/i.png';
    } catch (error) {
      print('Error While Uploading Image with title: $title');
      print(error.toString());
    }
    return 'error';
  }
}
