/// Utility class for date formatting with customizable options
class DateFormatter {
  /// Predefined date format patterns
  static const Map<CustomDateFormat, String> _formatPatterns = {
    CustomDateFormat.dayMonth: 'd MMM', // "11 Nov"
    CustomDateFormat.dayMonthWithDot: 'd MMM.', // "11 Nov."
    CustomDateFormat.monthDay: 'MMM d', // "Nov 11"
    CustomDateFormat.fullDate: 'd MMMM yyyy', // "11 November 2024"
    CustomDateFormat.shortDate: 'd/M/yy', // "11/11/24"
    CustomDateFormat.isoDate: 'yyyy-MM-dd', // "2024-11-11"
    CustomDateFormat.customDayMonth: 'dd MMM', // "11 Nov" (with leading zero)
    CustomDateFormat.dayMonthYear: 'd MMMM, yyyy', // "11 July, 2024"
  };

  /// Month abbreviations in English
  static const List<String> _monthAbbreviations = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  /// Full month names in English
  static const List<String> _monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

  /// Configuration for relative time thresholds
  static const _relativeTimeConfig = RelativeTimeConfig();

  /// Formats a date string into a relative time format
  /// Examples: "Now", "30s", "5m", "2h", "3d", "11/7", "Jul 24"
  static String formatRelativeTime(
    String dateStr, {
    RelativeTimeConfig? config,
    DateTime? referenceDate,
  }) {
    final effectiveConfig = config ?? _relativeTimeConfig;
    final parsedDate = DateTime.parse(dateStr);
    final now = referenceDate ?? DateTime.now();

    // Convert to UTC for consistent calculations
    final parsedUTCDate = DateTime.utc(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
      parsedDate.hour,
      parsedDate.minute,
      parsedDate.second,
      parsedDate.millisecond,
      parsedDate.microsecond,
    );

    final duration = now.difference(parsedUTCDate);

    // Return appropriate format based on duration
    if (duration.inSeconds < effectiveConfig.recentSeconds) {
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

    // For older dates, show month and year
    return '${_monthAbbreviations[parsedDate.month - 1]} ${parsedDate.year - 2000}';
  }

  /// Formats a date using the specified format pattern
  /// If no format is provided, defaults to DateFormat.dayMonthWithDot
  static String formatDate(
    DateTime date, {
    CustomDateFormat format = CustomDateFormat.dayMonthWithDot,
    String? customPattern,
  }) {
    if (customPattern != null) {
      return _formatWithCustomPattern(date, customPattern);
    }

    final pattern = _formatPatterns[format];
    if (pattern == null) return '${date.day} ${_monthAbbreviations[date.month - 1]}.';

    return _formatWithPattern(date, pattern);
  }

  /// Formats a date with a custom pattern
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

  /// Formats a date with a predefined pattern
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
}

/// Configuration class for relative time formatting
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
  dayMonth, // "11 Nov"
  dayMonthWithDot, // "11 Nov."
  monthDay, // "Nov 11"
  fullDate, // "11 November 2024"
  shortDate, // "11/11/24"
  isoDate, // "2024-11-11"
  customDayMonth, // "11 Nov" (with leading zero)
  dayMonthYear, // "11 July, 2024"
}
