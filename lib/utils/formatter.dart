String formatStringJson(String json) {
  return json.replaceAll('\\', '').replaceAll('"{', '{').replaceAll('}"', '}');
}
