import 'package:flutter/material.dart';

/// A sentence with some of its words set in a second style — the programme a
/// letter offers, the matriculation number in a student's byline.
///
/// The sentence arrives already localised and already filled in, and the
/// values to emphasise are passed beside it; the widget finds each one in the
/// text and wraps it. That keeps a translator's sentence whole in the ARB —
/// no `before`/`after` fragments to keep in step — and keeps the rendering of
/// a value out of the place that decides its words.
///
/// A value that is not in the text is simply not emphasised; the sentence is
/// never broken by a lookup that misses.
class EmphasisedText extends StatelessWidget {
  const EmphasisedText(
    this.text, {
    required this.style,
    required this.emphasisStyle,
    this.emphasis = const [],
    this.textAlign,
    super.key,
  });

  final String text;

  /// The substrings to set in [emphasisStyle], each matched once, in order.
  final List<String> emphasis;

  final TextStyle style;
  final TextStyle emphasisStyle;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(style: style, children: spans(text, emphasis, emphasisStyle)),
      textAlign: textAlign,
    );
  }

  /// [text] cut into plain and emphasised spans.
  ///
  /// Exposed so the splitting can be tested without a widget tree.
  static List<InlineSpan> spans(
    String text,
    List<String> emphasis,
    TextStyle emphasisStyle,
  ) {
    final result = <InlineSpan>[];
    var cursor = 0;

    for (final value in emphasis) {
      if (value.isEmpty) continue;
      final start = text.indexOf(value, cursor);
      if (start == -1) continue;

      if (start > cursor) {
        result.add(TextSpan(text: text.substring(cursor, start)));
      }
      result.add(TextSpan(text: value, style: emphasisStyle));
      cursor = start + value.length;
    }

    if (cursor < text.length) {
      result.add(TextSpan(text: text.substring(cursor)));
    }
    return result;
  }
}
