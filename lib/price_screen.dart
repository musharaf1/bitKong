import 'package:bitcoin_ticker/crypto_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = "USD";

  @override
  void initState() {
    updateUI();
    super.initState();
  }

  bool isWaiting = false;
  Map<String, String> coinValues = {};

  void updateUI() async {
    isWaiting = true;
    try {
      var data = await CryptoData().getCryptoPrice(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = data;
        print(coinValues);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Widget iosPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      print(currency);
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
        backgroundColor: Colors.lightBlue,
        itemExtent: 32,
        onSelectedItemChanged: (selecteIndex) {
          setState(() {
            selectedCurrency = currenciesList[selecteIndex];
            updateUI();
          });
        },
        children: pickerItems);
  }

  DropdownButton<String> androidDropdownButton() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (int i = 0; i < currenciesList.length; i++) {
      String currency = currenciesList[i];
      var newItem =
          DropdownMenuItem<String>(child: Text(currency), value: currency);
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
        value: selectedCurrency,
        items: dropdownItems,
        onChanged: (value) {
          setState(() {
            selectedCurrency = value;
            updateUI();
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CoinUpdateCard(
              bitcoinVal: 'BTC',
              cryptoPrice: coinValues['BTC'],
              selectedCurrency: selectedCurrency),
          CoinUpdateCard(
              bitcoinVal: "ETH",
              cryptoPrice: coinValues["ETH"],
              selectedCurrency: selectedCurrency),
          CoinUpdateCard(
              bitcoinVal: "LTC",
              cryptoPrice: coinValues['LTC'],
              selectedCurrency: selectedCurrency),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : androidDropdownButton(),
          ),
        ],
      ),
    );
  }
}

class CoinUpdateCard extends StatelessWidget {
  const CoinUpdateCard({
    Key key,
    @required this.bitcoinVal,
    @required this.cryptoPrice,
    @required this.selectedCurrency,
  }) : super(key: key);

  final String bitcoinVal;
  final String cryptoPrice;
  final String selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $bitcoinVal = $cryptoPrice $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
