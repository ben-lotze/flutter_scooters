import 'package:circ_flutter_challenge/blocs/price_calculator_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  test("test time formatter", () {

  });


  test("test currency formatter", () {
    PriceCalculatorBloc bloc = PriceCalculatorBloc();

    // TODO: add more currencies! -> is there a built-in way to get . or , in formatting? (as in Java)

    // de_DE
    expect(bloc.formatPriceInEuro(100, "€", locale: "de_DE"), "1 €");
    expect(bloc.formatPriceInEuro(120, "€", locale: "de_DE"), "1,2 €");
    expect(bloc.formatPriceInEuro(123, "€", locale: "de_DE"), "1,23 €");

    // en_US
    expect(bloc.formatPriceInEuro(100, "€", locale: "en_US"), "1 €");
    expect(bloc.formatPriceInEuro(120, "€", locale: "en_US"), "1.2 €");
    expect(bloc.formatPriceInEuro(123, "€", locale: "en_US"), "1.23 €");


    // test calculations, each started minute gets billed
    expect(bloc.calculateFormattedPriceForDuration(120, "€", Duration(seconds: 1), locale: "de_DE"), "2,2 €");
    expect(bloc.calculateFormattedPriceForDuration(120, "€", Duration(seconds: 61), locale: "de_DE"), "3,4 €");
    expect(bloc.calculateFormattedPriceForDuration(120, "€", Duration(seconds: 119), locale: "de_DE"), "3,4 €");
    expect(bloc.calculateFormattedPriceForDuration(120, "€", Duration(minutes: 3), locale: "de_DE"), "4,6 €");

  });

}