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
      print(res.reasonPhrase);
      return res.reasonPhrase;
    } catch (error) {
      print(error.toString());
    }
    return 'error';
  }
}
