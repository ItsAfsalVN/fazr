import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  final List<Permission> permissionsToRequest = [
    Permission.notification,
    Permission.scheduleExactAlarm,
  ];

  Map<Permission, PermissionStatus> statuses = await permissionsToRequest
      .request();

  statuses.forEach((permission, status) {
    if (status.isGranted) {
      print('${permission.toString()} was granted');
    } else if (status.isDenied) {
      print('${permission.toString()} was denied');
    } else if (status.isPermanentlyDenied) {
      print('${permission.toString()} was permanently denied.');
    }
  });
}
