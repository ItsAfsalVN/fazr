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

  final String newExtension = path.extension(image.path);
  final String newFileName = '$userId$newExtension';
  final String newUploadPath = 'avatars/$newFileName';
  final Uri newFileUrl = Uri.parse(
    'https://api.github.com/repos/$owner/$repo/contents/$newUploadPath',
  );

  final Map<String, String> headers = {
    'Authorization': 'Bearer $accessToken',
    'Accept': 'application/vnd.github+json',
    'Content-Type': 'application/json',
  };

  String? oldFilePath;
  String? oldFileSha;

  final Uri directoryUrl = Uri.parse(
    'https://api.github.com/repos/$owner/$repo/contents/avatars',
  );
  try {
    final response = await http.get(directoryUrl, headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> files = jsonDecode(response.body);
      for (final file in files) {
        if (file['name']?.startsWith(userId) == true) {
          oldFilePath = file['path'];
          oldFileSha = file['sha'];
          print('ℹ️ Found existing avatar at path: $oldFilePath');
          break;
        }
      }
    }
  } catch (e) {
    print("Could not check for existing files: $e");
  }

  if (oldFilePath != null &&
      oldFileSha != null &&
      oldFilePath != newUploadPath) {
    print('ℹ️ New avatar has a different extension. Deleting old one first.');
    try {
      final deleteUrl = Uri.parse(
        'https://api.github.com/repos/$owner/$repo/contents/$oldFilePath',
      );
      final deleteBody = jsonEncode({
        'message': 'chore: deleting old avatar for user $userId',
        'sha': oldFileSha,
        'committer': {'name': 'Fazr App', 'email': 'bot@fazr.app'},
      });
      await http.delete(deleteUrl, headers: headers, body: deleteBody);
      oldFileSha = null;
    } catch (e) {
      print(
        '❌ Failed to delete old avatar, proceeding with upload anyway. Error: $e',
      );
    }
  }

  try {
    final List<int> imageBytes = await image.readAsBytes();
    final String base64Content = base64Encode(imageBytes);

    final Map<String, dynamic> requestData = {
      'message': 'feat: Update avatar for user $userId',
      'content': base64Content,
      'committer': {'name': 'Fazr App', 'email': 'bot@fazr.app'},
    };

    if (oldFilePath == newUploadPath && oldFileSha != null) {
      requestData['sha'] = oldFileSha;
    }

    final String requestBody = jsonEncode(requestData);

    final response = await http.put(
      newFileUrl,
      headers: headers,
      body: requestBody,
    );

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


Future<String?> getAvatarUrlFromGitHub(String userId) async {
  if (accessToken == null || owner == null || repo == null) {
    print("Error: Missing GitHub environment variables.");
    return null;
  }

  final Uri url = Uri.parse('https://api.github.com/repos/$owner/$repo/contents/avatars');
  final Map<String, String> headers = {
    'Authorization': 'Bearer $accessToken',
    'Accept': 'application/vnd.github+json',
  };

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> files = jsonDecode(response.body);

      for (final file in files) {
        if (file is Map<String, dynamic> && file['name']?.startsWith(userId) == true) {
          final downloadUrl = file['download_url'];
          print('✅ Found GitHub avatar for $userId: $downloadUrl');
          return downloadUrl; // Return the URL as soon as it's found
        }
      }
      print('ℹ️ No avatar found on GitHub for user $userId.');
      return null;
    } else {
      print('❌ Could not list avatars from GitHub. Status: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('❌ An exception occurred while fetching avatar URL: $e');
    return null;
  }
}
