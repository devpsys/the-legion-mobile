/// Structural guardrails from ARCHITECTURE.md that the Dart analyzer cannot
/// express, checked as a test so a violation fails `flutter test` rather than
/// reaching review.
///
/// Rules enforced:
///   1. no private widget classes;
///   2. no hardcoded colour literals outside `lib/core/theme/`;
///   3. no user-facing string literals outside the ARB and fixtures;
///   4. no hardcoded spacing, padding, widths or heights in the presentation
///      layer;
///   5. widgets live in a feature's `widgets/` folder.
///
/// Each rule is a pure function over numbered source lines, so the `self-check`
/// group at the bottom can prove the detectors actually fire — a guardrail that
/// silently matches nothing is worse than none.
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const String _root = 'lib';

/// Matches a private widget: `class _Foo extends StatelessWidget`.
final RegExp _privateWidget = RegExp(
  r'^\s*(?:abstract\s+)?class\s+_[A-Za-z0-9_]+\s+extends\s+'
  r'(?:Stateless|Stateful)Widget',
);

/// Matches `Color(0x…)` and the Material `Colors.*` palette.
final RegExp _colourLiteral = RegExp(r'Color\(0x[0-9a-fA-F]{8}\)|\bColors\.\w');

/// Matches a quoted literal handed to copy, in both the forms an author
/// actually writes: an argument (`Text('…')`, `label: '…'`) and a field
/// default (`final String title = '…'`, `this.subtitle = '…'`).
///
/// The alternation requires a following `(`, `:` or `=`, so `title` matches but
/// `titlePrefix` does not.
final RegExp _copyLiteral = RegExp(
  r'\b(?:Text|RichText|label|title|subtitle|heading|caption|description|body|'
  r'hint|hintText|helperText|tooltip|errorText|placeholder|emptyText|message)'
  r"(?:\s*\(|\s*:\s*this\.|\s*=|\s*:)\s*'",
);

/// Matches a dimension given as a named argument: `width: 24`,
/// `minHeight: 4`, `size: 18` — but not `width: AppDimensions.rowHeight`, and
/// not `flex: 2`.
///
/// The dimension names are capitalised because Flutter's are (`minHeight`), and
/// `min`/`max` are matched as full words so `minimumTapTarget` is not caught.
final RegExp _dimensionArgument = RegExp(
  r'\b(?:[Ww]idth|[Hh]eight|[Ss]ize|[Ss]trokeWidth|[Rr]adius|'
  r'[Mm]in[Ww]idth|[Mm]in[Hh]eight|[Mm]ax[Ww]idth|[Mm]ax[Hh]ight)'
  r'\s*:\s*\d+(?:\.\d+)?\s*[,)]',
);

/// Matches a dimension passed positionally to a geometry constructor:
/// `EdgeInsets.all(16)`, `SizedBox(height: 20)`, `BorderRadius.circular(10)`.
///
/// Without this, the most idiomatic hardcoded padding in Flutter — an
/// `EdgeInsets` literal — slips past the named-argument pattern.
final RegExp _dimensionConstructor = RegExp(
  r'\b(?:EdgeInsets\.(?:all|only|symmetric|fromLTRB|fromLTWH)|'
  r'SizedBox|BoxConstraints|BorderRadius\.circular)'
  r'\([^)]*?\d+[^)]*?\)',
);

/// Matches a public widget class declaration.
final RegExp _widgetClass = RegExp(
  r'^class\s+[A-Z][A-Za-z0-9_]*\s+extends\s+(?:Stateless|Stateful)Widget',
);

/// Yields every hand-written Dart file under [directory], skipping generated
/// localisation output.
Iterable<File> dartFiles(String directory) sync* {
  final dir = Directory(directory);
  if (!dir.existsSync()) return;

  for (final entity in dir.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    if (entity.path.contains(
      '${Platform.pathSeparator}l10n${Platform.pathSeparator}gen',
    )) {
      continue;
    }
    yield entity;
  }
}

/// Source of [file] with 1-based line numbers, so failures point at a line.
List<String> numberedLines(File file) {
  var lineNumber = 0;
  return file
      .readAsLinesSync()
      .map((line) => '${++lineNumber}: $line')
      .toList();
}

/// The code of a numbered line, with the `12: ` prefix removed.
///
/// Locates the separator rather than using a fixed offset: the prefix length
/// varies with the line number, and a wrong offset lets a pattern match part
/// of a line number by accident.
String _codeOf(String line) {
  final separator = line.indexOf(': ');
  return separator == -1 ? line : line.substring(separator + 2);
}

/// Line numbers in [lines] whose *code* matches [pattern].
List<int> matchingLines(List<String> lines, RegExp pattern) => [
  for (var i = 0; i < lines.length; i++)
    if (pattern.hasMatch(_codeOf(lines[i]))) i + 1,
];

/// Joins violations into an assertion message.
String explain(String rule, List<String> violations) =>
    violations.isEmpty ? rule : '$rule\n${violations.join('\n')}';

/// Private widget classes anywhere under [directory].
List<String> findPrivateWidgets(String directory) => [
  for (final file in dartFiles(directory))
    for (final line in matchingLines(numberedLines(file), _privateWidget))
      '${file.path}:$line — private widget, rename it',
];

/// Colour literals outside `lib/core/theme/`.
List<String> findColourLiterals(String directory) => [
  for (final file in dartFiles(directory))
    if (!file.path.startsWith(
      'lib${Platform.pathSeparator}core${Platform.pathSeparator}theme',
    ))
      for (final line in matchingLines(numberedLines(file), _colourLiteral))
        '${file.path}:$line — use an AppColors token',
];

/// Copy literals outside the mock fixtures.
/// Copy literals in the presentation UI layer.
///
/// Scoped like [findHardcodedDimensions]: `bloc/`, `mock/` and `models/` are
/// exempt because they hold state, content and diagnostic text rather than
/// copy, and `core/` is out of scope entirely — nothing there reaches the user.
List<String> findCopyLiterals(String directory) {
  final violations = <String>[];

  for (final file in dartFiles(directory)) {
    if (!_isPresentationUi(file.path)) continue;

    for (final line in matchingLines(numberedLines(file), _copyLiteral)) {
      violations.add('${file.path}:$line — copy belongs in app_en.arb');
    }
  }

  return violations;
}

/// Hardcoded dimensions in the presentation layer.
///
/// [bloc], [mock] and [models] hold state and content, not layout, so their
/// numeric values are legitimate.
List<String> findHardcodedDimensions(String directory) {
  final violations = <String>[];

  for (final file in dartFiles(directory)) {
    if (!_isPresentationUi(file.path)) continue;

    final lines = numberedLines(file);
    for (final line in matchingLines(lines, _dimensionArgument)) {
      violations.add(
        '${file.path}:$line — use AppDimensions / AppSpacing / AppRadii',
      );
    }
    for (final line in matchingLines(lines, _dimensionConstructor)) {
      violations.add(
        '${file.path}:$line — use AppSpacing / AppDimensions / AppRadii',
      );
    }
  }

  return violations;
}

/// `true` for files that build UI, as opposed to state and content.
///
/// `bloc/`, `mock/` and `models/` hold numbers that are meant to be literals:
/// a countdown, a term date, a fee.
bool _isPresentationUi(String path) {
  if (!path.contains(
    '${Platform.pathSeparator}presentation${Platform.pathSeparator}',
  )) {
    return false;
  }
  return !['bloc', 'mock', 'models'].any(
    (folder) => path.contains(
      '${Platform.pathSeparator}$folder${Platform.pathSeparator}',
    ),
  );
}

/// Widget classes declared outside `pages/` and `widgets/`.
List<String> findMisplacedWidgets(String directory) => [
  for (final file in dartFiles(directory))
    if (!file.path.contains(
          '${Platform.pathSeparator}pages${Platform.pathSeparator}',
        ) &&
        !file.path.contains(
          '${Platform.pathSeparator}widgets${Platform.pathSeparator}',
        ))
      for (final line in matchingLines(numberedLines(file), _widgetClass))
        '${file.path}:$line — move this widget into presentation/widgets/',
];

void main() {
  group('policy 1 — no private widget classes', () {
    test('every widget class in lib/ is public', () {
      final violations = findPrivateWidgets(_root);

      expect(
        violations,
        isEmpty,
        reason: explain(
          'Private widget classes cannot be reused or tested directly.',
          violations,
        ),
      );
    });
  });

  group('policy 2 — no hardcoded colours', () {
    test('no colour literal outside lib/core/theme/', () {
      final violations = findColourLiterals(_root);

      expect(
        violations,
        isEmpty,
        reason: explain(
          'Colours are design decisions and belong in AppColors.',
          violations,
        ),
      );
    });
  });

  group('policy 3 — no user-facing string literals', () {
    test('widgets read their copy from the ARB', () {
      final violations = findCopyLiterals(_root);

      expect(
        violations,
        isEmpty,
        reason: explain('User-facing copy lives in the ARB.', violations),
      );
    });
  });

  group('policy 4 — no hardcoded dimensions in the presentation layer', () {
    test('presentation sizes come from the token scales', () {
      final violations = findHardcodedDimensions(_root);

      expect(
        violations,
        isEmpty,
        reason: explain(
          'Layout values belong in the token scales.',
          violations,
        ),
      );
    });
  });

  group('policy 5 — widgets live in a widgets folder', () {
    test('no widget class outside pages/ or widgets/', () {
      final violations = findMisplacedWidgets(
        'lib${Platform.pathSeparator}features',
      );

      expect(
        violations,
        isEmpty,
        reason: explain(
          "A widget belongs in its feature's widgets/ folder.",
          violations,
        ),
      );
    });
  });

  // A guardrail that silently matches nothing is worse than no guardrail, so
  // each detector is proven against both a compliant and a violating snippet.
  group('self-check — the detectors fire', () {
    /// Numbered lines for an in-memory snippet.
    List<String> lines(List<String> source) => [
      for (var i = 0; i < source.length; i++) '${i + 1}: ${source[i]}',
    ];

    test('policy 1 flags a private widget only', () {
      expect(
        matchingLines(
          lines(['class _Secret extends StatelessWidget {']),
          _privateWidget,
        ),
        isNotEmpty,
      );
      expect(
        matchingLines(
          lines(['class Public extends StatelessWidget {']),
          _privateWidget,
        ),
        isEmpty,
      );
      expect(
        matchingLines(
          lines(['class _State extends State<HomePage> {}']),
          _privateWidget,
        ),
        isEmpty,
        reason: 'State classes are not widgets and may be named for the page',
      );
    });

    test('policy 2 flags colours but not tokens', () {
      expect(
        matchingLines(
          lines(['color: Colors.red,', 'color: Color(0xFF00FF00),']),
          _colourLiteral,
        ),
        hasLength(2),
      );
      expect(
        matchingLines(
          lines(['color: AppColors.navy,', 'color: AppColors.successText(b),']),
          _colourLiteral,
        ),
        isEmpty,
        reason: 'AppColors is the token layer, not a literal',
      );
    });

    test('policy 3 flags copy in every form an author writes it', () {
      for (final literal in [
        r"Text('Sign out'),",
        r"label: 'Sign out',",
        r"this.subtitle = 'Do this next',",
        r"final String title = 'Everything else';",
        r"final String message = 'Rate limit hit';",
        r"tooltip: 'Open navigation menu',",
      ]) {
        expect(
          matchingLines(lines([literal]), _copyLiteral),
          hasLength(1),
          reason: 'should flag: $literal',
        );
      }
    });

    test('policy 3 allows localized copy and non-copy fields', () {
      for (final allowed in [
        'label: context.l10n.homeSignOut,',
        'Text(context.l10n.title),',
        r"final String identifier = 'internal-id';",
        r"final String route = 'features/auth';",
      ]) {
        expect(
          matchingLines(lines([allowed]), _copyLiteral),
          isEmpty,
          reason: 'should allow: $allowed',
        );
      }
    });

    test('policy 4 flags dimensions but not tokens or flex', () {
      expect(
        matchingLines(
          lines(['width: 24,', 'minHeight: 4,', 'size: 18.5,']),
          _dimensionArgument,
        ),
        hasLength(3),
      );
      expect(
        matchingLines(
          lines([
            'width: AppDimensions.rowHeight,',
            'padding: AppSpacing.md,',
            'flex: 2,',
          ]),
          _dimensionArgument,
        ),
        isEmpty,
      );
    });

    test('policy 4 flags positional geometry literals', () {
      for (final literal in [
        'padding: EdgeInsets.all(16),',
        'padding: EdgeInsets.symmetric(horizontal: 8),',
        'child: SizedBox(height: 20),',
        'borderRadius: BorderRadius.circular(10),',
      ]) {
        expect(
          matchingLines(lines([literal]), _dimensionConstructor),
          hasLength(1),
          reason: 'should flag: \$literal',
        );
      }
      for (final tokenised in [
        'padding: EdgeInsets.all(AppSpacing.md),',
        'child: const SizedBox.shrink(),',
        'padding: EdgeInsets.zero,',
        'child: SizedBox(height: AppDimensions.rowHeight),',
        'child: Flex(flex: 2),',
        'value: progress,',
      ]) {
        expect(
          matchingLines(lines([tokenised]), _dimensionConstructor),
          isEmpty,
          reason: 'should allow: \$tokenised',
        );
      }
    });

    test('policy 5 flags a widget class declaration', () {
      expect(
        matchingLines(
          lines(['class HubCard extends StatelessWidget {']),
          _widgetClass,
        ),
        hasLength(1),
      );
      expect(matchingLines(lines(['class HubTone {']), _widgetClass), isEmpty);
    });
  });
}
