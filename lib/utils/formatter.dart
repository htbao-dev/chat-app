String formatStringJson(String json) {
  return json.replaceAll('\\', '').replaceAll('"{', '{').replaceAll('}"', '}');
}

String getType(String subType) {
  if (subType.contains('jpeg')) {
    return 'image';
  }
  if (subType.contains('png')) {
    return 'image';
  }
  if (subType.contains('jpg')) {
    return 'image';
  }
  if (subType.contains('gif')) {
    return 'image';
  }
  if (subType.contains('mp4')) {
    return 'video';
  }
  if (subType.contains('mp3')) {
    return 'audio';
  }
  return 'file';
}

String getSubtype(String path) {
  return path.split('.').last;
}

String getTimeMesage(DateTime? time) {
  final now = DateTime.now();
  if (time == null) {
    return '';
  }
  final diff = now.difference(time);
  if (diff.inMinutes < 1) {
    return 'Vừa xong';
  }
  if (diff.inMinutes < 60) {
    return '${diff.inMinutes} phút trước';
  }
  if (diff.inHours < 24) {
    return '${diff.inHours} giờ trước';
  }
  if (diff.inDays < 7) {
    return '${diff.inDays} ngày trước';
  }
  return '${time.day}/${time.month}/${time.year}';
}
