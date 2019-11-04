import 'package:circ_flutter_challenge/base/formatters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  test("test time formatter", () {
    expect(TimeFormatter.formatTime(45), "45 s");
    expect(TimeFormatter.formatTime(60), "1 min");
    expect(TimeFormatter.formatTime(66), "1m 6s");
    expect(TimeFormatter.formatTime(180), "3 minutes");
    expect(TimeFormatter.formatTime(181), "3m 1s");
  });


  test("test price calculator and formatter", () {

    // de_DE
    expect(PriceFormatter.formatPrice(100, "€", locale: "de_DE"), "1 €");
    expect(PriceFormatter.formatPrice(120, "€", locale: "de_DE"), "1,2 €");
    expect(PriceFormatter.formatPrice(123, "€", locale: "de_DE"), "1,23 €");

    // en_US
    expect(PriceFormatter.formatPrice(100, "€", locale: "en_US"), "1 €");
    expect(PriceFormatter.formatPrice(120, "€", locale: "en_US"), "1.2 €");
    expect(PriceFormatter.formatPrice(123, "€", locale: "en_US"), "1.23 €");


    // test calculations: each started minute gets billed
    expect(PriceFormatter.formatPriceForDuration(120, "€", Duration(seconds: 1), locale: "de_DE"), "2,2 €");
    expect(PriceFormatter.formatPriceForDuration(120, "€", Duration(seconds: 61), locale: "de_DE"), "3,4 €");
    expect(PriceFormatter.formatPriceForDuration(120, "€", Duration(seconds: 119), locale: "de_DE"), "3,4 €");
    expect(PriceFormatter.formatPriceForDuration(120, "€", Duration(minutes: 3), locale: "de_DE"), "4,6 €");
    // and one more for en_US
    expect(PriceFormatter.formatPriceForDuration(120, "\$", Duration(seconds: 181), locale: "en_EN"), "5.8 \$");
  });

}