import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:io' as plat show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  late String currentCurrency = 'USD';

  DropdownButton<String> Androidpicker() {
    List<DropdownMenuItem<String>> dropDownitems = [];
    for (String currency in currenciesList) {
      var newItems = DropdownMenuItem(child: Text(currency), value: currency);
      dropDownitems.add(newItems);
    }
    return DropdownButton<String>(
      value: currentCurrency,
      items: dropDownitems,
      onChanged: (value) {
        setState(() {
          currentCurrency = value!;
          getData();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
        backgroundColor: Colors.lightBlue,
        itemExtent: 32.0,
        onSelectedItemChanged: (selectedIndex) {
          setState(() {
            currentCurrency = currenciesList[selectedIndex];
          });
        },
        children: pickerItems);
  }

  Widget getPicker() {
    if (plat.Platform.isIOS) {
      return iOSPicker();
    } else if (plat.Platform.isAndroid) {
      return Androidpicker();
    }
    return Androidpicker();
  }

  late String bitCoinValueInUSD = '?';

  var valueList;

  void getData() async {
    isWaiting = true;
    try {
      var coinData = await CoinData().getCoinData(currentCurrency);
      isWaiting = false;
      setState(() {
        coinValues = coinData;
        valueList = coinValues.values.toList();
      });
    } catch (e) {
      print(e);
    }
  }

  Map<String, String> coinValues = {};
  bool isWaiting = false;

  @override
  void initState() {
    super.initState();
    getData();
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CryptoCard(
                  cryptoCurrency: 'BTC',
                  value: isWaiting ? '?' : valueList[0],
                  selectedCurrency: currentCurrency),
              CryptoCard(
                  cryptoCurrency: 'ETH',
                  value: isWaiting ? '?' : valueList[1],
                  selectedCurrency: currentCurrency),
              CryptoCard(
                  cryptoCurrency: 'LTC',
                  value: isWaiting ? '?' : valueList[2],
                  selectedCurrency: currentCurrency),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child:
                Androidpicker(), //plat.Platform.isIOS ? iOSPicker() : Androidpicker(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  CryptoCard({
    required this.value,
    required this.selectedCurrency,
    required this.cryptoCurrency,
  });

  late String value;
  late String selectedCurrency;
  late String cryptoCurrency;

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
            '1 $cryptoCurrency = $value $selectedCurrency',
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
