import 'package:http/http.dart' as http;

class UploadService {
  static Future<String> uploadImage(String title, String path) async {
    const url = 'http://10.0.2.2:3000/files/uploadFile';
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(
        await http.MultipartFile.fromPath('picture', path),
      );
      var res = await request.send();
      var response = await http.Response.fromStream(res);
      print(response.body);
      var id = response.body.substring(1, response.body.length - 1);
      return 'http://10.0.2.2:5984/images/$id/i.png';
    } catch (error) {
      print('Error While Uploading Image with title: $title');
      print(error.toString());
    }
    return 'error';
  }
}
