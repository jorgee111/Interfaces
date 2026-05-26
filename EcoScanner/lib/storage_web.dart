import 'dart:html' as html;

String? readValue(String key) => html.window.localStorage[key];

void writeValue(String key, String value) {
  html.window.localStorage[key] = value;
}
