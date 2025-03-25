import 'package:intl/intl.dart' as intl;

// Suppress naming issues as changes would breaking.
// ignore_for_file: non_constant_identifier_names, constant_identifier_names

/// A complete drop-in replacement for intl.DateFormat with additional utility methods
class DateFormat {
  final intl.DateFormat _internalFormat;
  final bool _utc;

  DateFormat([String pattern = '', bool utc = false, String? locale])
      : _utc = utc,
        _internalFormat = intl.DateFormat(pattern, locale);

  // =============================================
  // Factory constructors matching intl.DateFormat
  // =============================================

  // Date formats
  factory DateFormat.d([String? locale]) => DateFormat('d', false, locale);

  factory DateFormat.E([String? locale]) => DateFormat('E', false, locale);

  factory DateFormat.EEEE([String? locale]) => DateFormat('EEEE', false, locale);

  factory DateFormat.EEEEE([String? locale]) => DateFormat('EEEEE', false, locale);

  factory DateFormat.LLL([String? locale]) => DateFormat('LLL', false, locale);

  factory DateFormat.LLLL([String? locale]) => DateFormat('LLLL', false, locale);

  factory DateFormat.M([String? locale]) => DateFormat('M', false, locale);

  factory DateFormat.Md([String? locale]) => DateFormat('Md', false, locale);

  factory DateFormat.MEd([String? locale]) => DateFormat('MEd', false, locale);

  factory DateFormat.MMM([String? locale]) => DateFormat('MMM', false, locale);

  factory DateFormat.MMMd([String? locale]) => DateFormat('MMMd', false, locale);

  factory DateFormat.MMMEd([String? locale]) => DateFormat('MMMEd', false, locale);

  factory DateFormat.MMMM([String? locale]) => DateFormat('MMMM', false, locale);

  factory DateFormat.MMMMd([String? locale]) => DateFormat('MMMMd', false, locale);

  factory DateFormat.MMMMEEEEd([String? locale]) => DateFormat('MMMMEEEEd', false, locale);

  factory DateFormat.QQQ([String? locale]) => DateFormat('QQQ', false, locale);

  factory DateFormat.QQQQ([String? locale]) => DateFormat('QQQQ', false, locale);

  factory DateFormat.y([String? locale]) => DateFormat('y', false, locale);

  factory DateFormat.yM([String? locale]) => DateFormat('yM', false, locale);

  factory DateFormat.yMd([String? locale]) => DateFormat('yMd', false, locale);

  factory DateFormat.yMEd([String? locale]) => DateFormat('yMEd', false, locale);

  factory DateFormat.yMMM([String? locale]) => DateFormat('yMMM', false, locale);

  factory DateFormat.yMMMd([String? locale]) => DateFormat('yMMMd', false, locale);

  factory DateFormat.yMMMEd([String? locale]) => DateFormat('yMMMEd', false, locale);

  factory DateFormat.yMMMM([String? locale]) => DateFormat('yMMMM', false, locale);

  factory DateFormat.yMMMMd([String? locale]) => DateFormat('yMMMMd', false, locale);

  factory DateFormat.yMMMMEEEEd([String? locale]) => DateFormat('yMMMMEEEEd', false, locale);

  factory DateFormat.yQQQ([String? locale]) => DateFormat('yQQQ', false, locale);

  factory DateFormat.yQQQQ([String? locale]) => DateFormat('yQQQQ', false, locale);

  // Time formats
  factory DateFormat.H([String? locale]) => DateFormat('H', false, locale);

  factory DateFormat.Hm([String? locale]) => DateFormat('Hm', false, locale);

  factory DateFormat.Hms([String? locale]) => DateFormat('Hms', false, locale);

  factory DateFormat.j([String? locale]) => DateFormat('j', false, locale);

  factory DateFormat.jm([String? locale]) => DateFormat('jm', false, locale);

  factory DateFormat.jms([String? locale]) => DateFormat('jms', false, locale);

  // UTC variants
  factory DateFormat.d_UTC([String? locale]) => DateFormat('d', true, locale);

  factory DateFormat.E_UTC([String? locale]) => DateFormat('E', true, locale);

  // =============================================
  // Parsing Methods
  // =============================================

  DateTime parse(String inputString, [bool utc = false]) {
    return _parse(inputString, utc: utc);
  }

  DateTime parseStrict(String inputString, [bool utc = false]) {
    return _parse(inputString, utc: utc, strict: true);
  }

  DateTime? tryParse(String inputString, [bool utc = false]) {
    try {
      return parse(inputString, utc);
    } on FormatException {
      return null;
    }
  }

  DateTime? tryParseStrict(String inputString, [bool utc = false]) {
    try {
      return parseStrict(inputString, utc);
    } on FormatException {
      return null;
    }
  }

  DateTime _parse(String inputString, {bool utc = false, bool strict = false}) {
    try {
      final date = _internalFormat.parse(inputString, strict);
      return utc ? date.toUtc() : date.toLocal();
    } catch (e) {
      throw FormatException('Failed to parse date: $inputString', inputString);
    }
  }

  /// UTC-specific parsing
  DateTime parseUTC(String inputString) => _parse(inputString, utc: true);

  DateTime parseUtc(String inputString) => _parse(inputString, utc: true);

  DateTime? tryParseUtc(String inputString) {
    try {
      return parseUtc(inputString);
    } on FormatException {
      return null;
    }
  }

  // =============================================
  // Formatting Methods
  // =============================================

  String format(DateTime date) {
    final dateToFormat = _utc ? date.toUtc() : date;
    return _internalFormat.format(dateToFormat);
  }

  // =============================================
  // Custom Utility Methods
  // =============================================

  static String formatRelativeTime(
    String dateStr, {
    RelativeTimeConfig? config,
    DateTime? referenceDate,
  }) {
    final effectiveConfig = config ?? _relativeTimeConfig;
    final parsedDate = DateTime.parse(dateStr);
    final parsedUTCDate = parsedDate.toUtc();
    final now = (referenceDate?.toUtc() ?? DateTime.now().toUtc());

    final duration = now.difference(parsedUTCDate);

    if (duration.inSeconds.abs() < effectiveConfig.recentSeconds) {
      return effectiveConfig.justNowText;
    }
    if (duration.inSeconds < effectiveConfig.secondsThreshold) {
      return '${duration.inSeconds}${effectiveConfig.secondsSuffix}';
    }
    if (duration.inMinutes < effectiveConfig.minutesThreshold) {
      return '${duration.inMinutes}${effectiveConfig.minutesSuffix}';
    }
    if (duration.inHours < effectiveConfig.hoursThreshold) {
      return '${duration.inHours}${effectiveConfig.hoursSuffix}';
    }
    if (duration.inDays < effectiveConfig.daysThreshold) {
      return '${duration.inDays}${effectiveConfig.daysSuffix}';
    }
    if (duration.inDays < effectiveConfig.monthThreshold) {
      return '${parsedDate.day}/${parsedDate.month}';
    }
    return '${_monthAbbreviations[parsedDate.month - 1]} ${parsedDate.year - 2000}';
  }

  /// Formats a date using custom format options
  static String formatDate(
    DateTime date, {
    CustomDateFormat format = CustomDateFormat.dayMonthWithDot,
    String? customPattern,
  }) {
    if (customPattern != null) {
      return _formatWithCustomPattern(date, customPattern);
    }
    final pattern = _formatPatterns[format];
    return pattern != null ? _formatWithPattern(date, pattern) : '${date.day} ${_monthAbbreviations[date.month - 1]}.';
  }

  /// Formats time remaining into HH:MM:SS format
  static String formatTimeRemaining(int hours, int minutes, int seconds) {
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Formats a price with two decimal places and a dollar sign
  static String formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }

  // =============================================
  // Internal Implementation
  // =============================================

  static String _formatWithCustomPattern(DateTime date, String pattern) {
    return pattern
        .replaceAll('MMMM', _monthNames[date.month - 1])
        .replaceAll('MMM', _monthAbbreviations[date.month - 1])
        .replaceAll('MM', date.month.toString().padLeft(2, '0'))
        .replaceAll('M', date.month.toString())
        .replaceAll('dd', date.day.toString().padLeft(2, '0'))
        .replaceAll('d', date.day.toString())
        .replaceAll('yyyy', date.year.toString())
        .replaceAll('yy', date.year.toString().substring(2));
  }

  static String _formatWithPattern(DateTime date, String pattern) {
    return _formatWithCustomPattern(date, pattern);
  }

  /// Returns the abbreviated month name
  static String getMonthAbbreviation(int month) {
    if (month < 1 || month > 12) {
      throw ArgumentError('Month must be between 1 and 12');
    }
    return _monthAbbreviations[month - 1];
  }

  /// Returns the full month name
  static String getMonthName(int month) {
    if (month < 1 || month > 12) {
      throw ArgumentError('Month must be between 1 and 12');
    }
    return _monthNames[month - 1];
  }

  // =============================================
  // Constants
  // =============================================

  static const Map<CustomDateFormat, String> _formatPatterns = {
    CustomDateFormat.dayMonth: 'd MMM',
    CustomDateFormat.dayMonthWithDot: 'd MMM.',
    CustomDateFormat.monthDay: 'MMM d',
    CustomDateFormat.fullDate: 'd MMMM yyyy',
    CustomDateFormat.shortDate: 'd/M/yy',
    CustomDateFormat.isoDate: 'yyyy-MM-dd',
    CustomDateFormat.customDayMonth: 'dd MMM',
    CustomDateFormat.dayMonthYear: 'd MMMM, yyyy',
  };

  static const List<String> _monthAbbreviations = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  static const List<String> _monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

  static const _relativeTimeConfig = RelativeTimeConfig();
}

/// Configuration for relative time formatting
class RelativeTimeConfig {
  final int recentSeconds;
  final int secondsThreshold;
  final int minutesThreshold;
  final int hoursThreshold;
  final int daysThreshold;
  final int monthThreshold;

  final String justNowText;
  final String secondsSuffix;
  final String minutesSuffix;
  final String hoursSuffix;
  final String daysSuffix;

  const RelativeTimeConfig({
    this.recentSeconds = 30,
    this.secondsThreshold = 99,
    this.minutesThreshold = 60,
    this.hoursThreshold = 23,
    this.daysThreshold = 7,
    this.monthThreshold = 30,
    this.justNowText = 'Now',
    this.secondsSuffix = 's',
    this.minutesSuffix = 'm',
    this.hoursSuffix = 'h',
    this.daysSuffix = 'd',
  });
}

/// Available date format options
enum CustomDateFormat {
  dayMonth,
  dayMonthWithDot,
  monthDay,
  fullDate,
  shortDate,
  isoDate,
  customDayMonth,
  dayMonthYear,
}
