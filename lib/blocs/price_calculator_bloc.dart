class PriceCalculatorBloc {

  int get basePriceInCents => 100;

  String formatPriceInEuro(int cents, String currency) {
    return "${(cents/100).toStringAsFixed(2)} $currency";
  }

  String calculateFormattedPriceForDuration(int cents, String currency, Duration duration) {
    // each started (!) minute counts
    int minutes = duration.inMinutes.floor();
    int endPrice = basePriceInCents + (cents * minutes);
    return formatPriceInEuro(endPrice, currency);
  }


  dispose() {
    // nothing to dispose
  }

}