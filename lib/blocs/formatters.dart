import 'package:intl/intl.dart';


class PriceFormatter {

  /// base price for unlocking a vehicle
  static const int BASE_PRICE_CENTS = 100;

  /// Formatting will use current locale, this can be overridden by specifying a custom [locale] like 'en_US' or 'de_DE'.
  /// <br>The returned String will only contain necessary digits, i.e.
  /// <br>cents=100 -> 1 €
  /// <br>cents=120 -> 1.2 €
  /// <br>cents=133 -> 1.33 €
  static String formatPrice(int cents, String currency, {String locale}) {
    NumberFormat format = locale != null ? NumberFormat('###.##', locale) : NumberFormat('###.##');
    String result = "${format.format(cents/100)} $currency" ;
    return result;
  }


  /// Each started (!) minute gets billed, even if it's a second.
  /// <br>Formatting will use current locale, this can be overridden by specifying a custom [locale].
  /// <br> For more info about formatting, see [PriceFormatter.formatPrice].
  static String formatPriceForDuration(int cents, String currency, Duration duration, {String locale}) {
    int seconds = duration.inSeconds;
    int minutes = (seconds / 60).floor();
    int secondsRest = seconds % 60;
    if (secondsRest >= 1) {
      minutes++;
    }
    int endPrice = BASE_PRICE_CENTS + (cents * minutes);
    return formatPrice(endPrice, currency, locale: locale);
  }

}


class TimeFormatter {

  static String formatTime(int seconds) {
    if (seconds < 60) {
      return "$seconds s";
    }
    else if (seconds == 60) {
      return "1 min";
    }

    int minutes = seconds ~/ 60;
    int restSeconds = seconds % 60;
    if(restSeconds > 0) {
      return "${minutes}m ${restSeconds}s";
    }

    // rest == 0
    return "$minutes minutes";
  }
}