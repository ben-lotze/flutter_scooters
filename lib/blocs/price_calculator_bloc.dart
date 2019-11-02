import 'package:intl/intl.dart';

class PriceCalculatorBloc {

  /// base price for unlocking a vehicle
  int get basePriceInCents => 100;

  /// Formatting will use current locale, this can be overridden by specifying a custom [locale].
  /// <br>The returned String will only contain necessary digits, i.e.
  /// <br>cents=100 -> 1 €
  /// <br>cents=120 -> 1.2 €
  /// <br>cents=133 -> 1.33 €
  String formatPriceInEuro(int cents, String currency, {String locale}) {
    NumberFormat format = locale != null ? NumberFormat('###.##', locale) : NumberFormat('###.##');   // , 'en_US', 'de_DE'
    String resultIntl = "${format.format(cents/100)} $currency" ;
    return resultIntl;
  }

  /// Each started (!) minute gets billed, even if it's a second.
  /// <br>Formatting will use current locale, this can be overridden by specifying a custom [locale].
  /// <br> For more info about formatting, see [PriceCalculatorBloc.formatPriceInEuro].
  String calculateFormattedPriceForDuration(int cents, String currency, Duration duration, {String locale}) {
    int seconds = duration.inSeconds;
    int minutes = (seconds / 60).floor();
    int secondsRest = seconds % 60;
    if (secondsRest >= 1) {
      minutes++;
    }
    int endPrice = basePriceInCents + (cents * minutes);
    return formatPriceInEuro(endPrice, currency, locale: locale);
  }


  dispose() {
    // nothing to dispose
  }

}