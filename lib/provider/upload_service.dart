import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as mime;

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
      var id = response.body.substring(1, response.body.length - 2);
      return '/images/$id/i.png';
    } catch (error) {
      print('Error While Uploading Image with title: $title');
      print(error.toString());
    }
    return '';
  }

  static Future<String> uploadVideo(String title, String path) async {
    var ending = path.split(".").last;
    print('Video Upload with ending: $ending');
    var url = Config.backendURL + '/v1/videos';
    try {
      var request = http.MultipartRequest('PUT', Uri.parse(url));
      request.files.add(
        await http.MultipartFile.fromPath(
          'videoFile',
          path,
          contentType: mime.MediaType('video', 'mp4'),
        ),
      );
      var res = await request.send();
      var response = await http.Response.fromStream(res);
      var id = response.body.substring(1, response.body.length - 2);
      // return '/videos/$id/v.$ending';
      return '/videos/$id/v.mp4';
    } catch (error) {
      print('Error While Uploading Image with title: $title');
      print(error.toString());
    }
    return '';
  }
}
