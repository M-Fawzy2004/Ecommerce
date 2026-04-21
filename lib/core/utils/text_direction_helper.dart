import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class TextDirectionHelper {
  static bool isRtl(String text) {
    if (text.isEmpty) return false;
    return intl.Bidi.hasAnyRtl(text);
  }

  static TextAlign getTextAlign(String text) {
    return isRtl(text) ? TextAlign.right : TextAlign.left;
  }

  static CrossAxisAlignment getCrossAxisAlignment(String text) {
    return isRtl(text) ? CrossAxisAlignment.end : CrossAxisAlignment.start;
  }

  static TextDirection getTextDirection(String text) {
    return isRtl(text) ? TextDirection.rtl : TextDirection.ltr;
  }
}
