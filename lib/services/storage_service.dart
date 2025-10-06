import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

final String? accessToken = dotenv.env['GITHUB_ACCES_TOKEN'];
final String? owner = dotenv.env['GITHUB_OWNER'];
final String? repo = dotenv.env['GITHUB_REPO'];

Future<String?> uploadAvatar(XFile image, String userId) async {
  if (accessToken == null || owner == null || repo == null) {
    print("Error: Missing GitHub environment variables.");
    return null;
  }

  final String extension = path.extension(image.path);
  final String fileName = '$userId$extension';
  final String uploadPath = 'avatars/$fileName';

  final Uri url = Uri.parse(
    'https://api.github.com/repos/$owner/$repo/contents/$uploadPath',
  );
  final Map<String, String> headers = {
    'Authorization': 'Bearer $accessToken',
    'Accept': 'application/vnd.github+json',
    'Content-Type': 'application/json',
  };

  String? existingFileSha;

  try {
    final getResponse = await http.get(url, headers: headers);
    if (getResponse.statusCode == 200) {
      final responseData = jsonDecode(getResponse.body);
      existingFileSha = responseData['sha'];
      print(
        'ℹ️ Existing avatar found. Preparing to update file with SHA: $existingFileSha',
      );
    } else {
      print('ℹ️ No existing avatar found. A new one will be created.');
    }
  } catch (e) {
    print("Could not check for existing file, proceeding with create: $e");
  }

  try {
    final List<int> imageBytes = await image.readAsBytes();
    final String base64Content = base64Encode(imageBytes);

    final Map<String, dynamic> requestData = {
      'message': 'feat: Update avatar for user $userId',
      'content': base64Content,
      'committer': {'name': 'Fazr App', 'email': 'bot@fazr.app'},
    };

    if (existingFileSha != null) {
      requestData['sha'] = existingFileSha;
    }

    final String requestBody = jsonEncode(requestData);

    final response = await http.put(url, headers: headers, body: requestBody);

    if (response.statusCode == 201 || response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String? downloadUrl = responseData['content']['download_url'];
      print('✅ Avatar uploaded successfully: $downloadUrl');
      return downloadUrl;
    } else {
      print('❌ Failed to upload avatar. Status: ${response.statusCode}');
      print('Error details: ${response.body}');
      return null;
    }
  } catch (e) {
    print('❌ An exception occurred during upload: $e');
    return null;
  }
}
