import 'dart:convert';

import 'package:http/http.dart';

extension ResponseExtensions on Response {
  Map<String, dynamic> toMap() => json.decode(body) as Map<String, dynamic>;
}
