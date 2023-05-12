import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:add_to_google_wallet/widgets/add_to_google_wallet_button.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // static const platformChannel =
  //     MethodChannel('test.connect.methodchannel/iOS');
  // String _iosText = 'IOS result';
  // Future<void> _getStringIOS() async {
  //   String _result;
  //   try {
  //     final String result = await platformChannel.invokeMethod('checkTest');
  //     _result = result;
  //   } catch (e) {
  //     _result = "Can't fetch the method: '$e'.";
  //   }

  //   setState(() {
  //     _iosText = _result;
  //   });
  // }

  static String _passId = const Uuid().v4();
  static String _passClass = 'skux';
  static String _issuerId = '3388000000022226545';
  static String _issuerEmail =
      'osmer-services@decoded-nebula-385812.iam.gserviceaccount.com';
  static String balance = "\$3213.28";

  // "barcode": {
  //         "type": "QR_CODE",
  //         "value": "$_passId"
  //       },
  //       "heroImage": {
  //         "sourceUri": {
  //           "uri": "https://skux.io/wp-content/uploads/2022/11/SKUx-logo-2-color-blue.png"
  //         }
  //       },
  final String _examplePass = """ 
    {
        "iss": "$_issuerEmail",
        "aud": "google",
        "typ": "savetowallet",
        "origins": [],
        "payload": {
          "genericObjects": [
            {
              "id": "$_issuerId.$_passId",
              "classId": "$_issuerId.$_passClass",
              "logo": {
                "sourceUri": {
                  "uri": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTq7Un_FXwWPhLTaDovpYxvrUHTTNawLWE-tm3Aj_yOL_nn9KYNf2SSD8Y4h9uiPA2VIQM&usqp=CAU"
                },
                "contentDescription": {
                  "defaultValue": {
                    "language": "en",
                    "value": "LOGO_IMAGE_DESCRIPTION"
                  }
                }
              },
              "cardTitle": {
                "defaultValue": {
                  "language": "en",
                  "value": "Walmart"
                }
              },
              "subheader": {
                "defaultValue": {
                  "language": "en",
                  "value": "Card Number"
                }
              },
              "header": {
                "defaultValue": {
                  "language": "en",
                  "value": "8978777777777"
                }
              },
              "textModulesData": [
                {
                  "id": "balance",
                  "header": "Balance",
                  "body": "\$899.18"
                },
                {
                  "id": "powerd_by_",
                  "header": "Powerd by ",
                  "body": "SKUx"
                },
                {
                  "id": "offer",
                  "header": "Offer",
                  "body": "20% off"
                },
                {
                  "id": "valid_till",
                  "header": "Valid Till",
                  "body": "Dec 31, 2023"
                }
              ],
              "barcode": {
                "type": "QR_CODE",
                "value": "$_passId",
                "alternateText": ""
              },
              "hexBackgroundColor": "#4285f4",
              "heroImage": {
                "sourceUri": {
                  "uri": "https://stageassets.skux.io/offer-assets/ba86d333-d9e9-42a9-b23a-f906229ab6a2/1c4aff47-664a-4263-8ea5-c62236b8138c-ef78bde5-9b88-4fc1-b3cf-1edd84490e11-chicken-grill-mobile3-01-source-source-small.png"
                },
                "contentDescription": {
                  "defaultValue": {
                    "language": "en",
                    "value": "HERO_IMAGE_DESCRIPTION"
                  }
                }
              }
            }
          ]
        }
      }
""";

  void _showSnackBar(BuildContext context, String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  @override
  Widget build(BuildContext context) {
    const String viewType = '<platform-view-type>';
    final Map<String, dynamic> creationParams = <String, dynamic>{};
    return defaultTargetPlatform == TargetPlatform.android
        ? Scaffold(
            appBar: AppBar(title: const Text('Plugin example app')),
            body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AddToGoogleWalletButton(
                      pass: _examplePass,
                      onSuccess: () => _showSnackBar(context, 'Success!'),
                      onCanceled: () =>
                          _showSnackBar(context, 'Action canceled.'),
                      onError: (Object error) =>
                          _showSnackBar(context, error.toString()),
                      locale: const Locale.fromSubtags(
                        languageCode: 'en',
                        countryCode: 'US',
                      ),
                    )
                  ]),
            ),
          )
        : UiKitView(
            viewType: viewType,
            layoutDirection: TextDirection.ltr,
            creationParams: creationParams,
            creationParamsCodec: const StandardMessageCodec(),
          );
  }
}
