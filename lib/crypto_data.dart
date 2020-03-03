import 'package:http/http.dart' as http;
import 'dart:convert';

const apiKkey = 'F6088644-E9C2-4A85-83C9-093192B14C71';
const coinUrl = 'https://rest.coinapi.io/v1/exchangerate';

class CryptoData {
  Future<dynamic> getCryptoPrice(String selectedCurrency) async {
    Map<String, String> cryptoPrices = {};
    for (String crypto in cryptoList) {
      String requestURL = '$coinUrl/$crypto/$selectedCurrency?apiKey=$apiKkey';
      http.Response response = await http.get(requestURL);

      if (response.statusCode == 200) {
        var decodedData = json.decode(response.body);
        double lastPrice = decodedData['rate'];
        cryptoPrices[crypto] = lastPrice.toStringAsFixed(0);
      } else {
        print(response.statusCode);
        throw "Problem with http request";
      }
    }
    return cryptoPrices;
  }
}

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR',
  'NGN',
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];
