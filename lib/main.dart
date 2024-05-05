import 'package:flutter/material.dart';
import 'package:optiprice_ai/util/get.dart';
import 'package:optiprice_ai/widgets/input_cont.dart';
import 'package:optiprice_ai/widgets/result_cont.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool loading = false;
  String dataset = 'retail_price';
  String product = 'bed1';
  String field = 'month_year';
  String value = DateTime.now().toIso8601String().substring(0, 10);

  Widget inputCont = Container();

  Map<String, dynamic> results = {};

  @override
  void initState() {
    super.initState();

    setState(() {
      inputCont = InputCont(
        onChangeDataset: (dataset) {
          setState(() {
            this.dataset = dataset;
          });
        },
        onChangeField: (field) {
          setState(() {
            this.field = field;
          });
        },
        onChangeProduct: (product) {
          setState(() {
            this.product = product;
          });
        },
        onChangeValue: (value) {
          setState(() {
            this.value = value;
          });
        },
        onProductsLoaded: (products) {
          setState(() {
            product = products[0];
          });
        },
        onOptimize: (product, field, value, dataset) async {
          setState(() {
            loading = true;
          });
          try {
            final res = await getResults(product, field, value, dataset);
            setState(() {
              results = res;
            });
          } catch (e) {
            print(e);
          }
          setState(() {
            loading = false;
          });
        }, enabled: !loading,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFD8DCFF), Color(0xFF7785FF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                inputCont,
                const SizedBox(width: 20),
                ResultCont(
                  loading: loading,
                  onLoadingStateChanged: (l) => setState(() {
                    loading = l;
                  }),
                  product: product,
                  field: field,
                  value: value,
                  results: results, dataset: dataset,
                ),
              ],
            )),
      ),
    );
  }
}
