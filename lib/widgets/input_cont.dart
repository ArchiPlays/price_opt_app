import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:optiprice_ai/util/data_object.dart';
import 'package:optiprice_ai/util/get.dart';
import 'package:optiprice_ai/widgets/custom_dropdown_btn.dart';
import 'package:optiprice_ai/widgets/welcome_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class InputCont extends StatefulWidget {
  final Function onChangeDataset;
  final Function onChangeProduct;
  final Function onChangeField;
  final Function onChangeValue;
  final Function onProductsLoaded;
  final Function onOptimize;
  final bool enabled;

  const InputCont(
      {super.key,
      required this.onChangeProduct,
      required this.onChangeField,
      required this.onChangeValue,
      required this.onProductsLoaded,
      required this.onOptimize,
      required this.enabled,
      required this.onChangeDataset});

  @override
  State<InputCont> createState() => _InputContState();
}

class _InputContState extends State<InputCont> {
  List<Map<String, dynamic>> datasets = [];
  List<String> products = [];

  List<DataObject> tableData = [];

  String currentDataset = '';
  String currentProduct = '';

  String field = 'month_year';
  String value = DateTime.now().toIso8601String().substring(0, 10);

// initializing state and loading data
  @override
  void initState() {
    super.initState();
    getDatasets().then((value) {
      setState(() {
        datasets = value;
        datasets.sort((a, b) => a['name'].compareTo(b['name']));
        currentDataset = datasets[0]['name'];

        getProducts(currentDataset).then((value1) {
          setState(() {
            products = value1;
            products.sort((a, b) => a.compareTo(b));
            currentProduct = products[0];

            getTableData(currentProduct, currentDataset).then((value2) {
              setState(() {
                tableData = value2;
              });
            });

            widget.onProductsLoaded(products);
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8 > 400
          ? 400
          : MediaQuery.of(context).size.width * 0.8,
      height: 620,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 25,
          ),
          WelcomeWidget(
            showGraphDialog: showGraphDialog,
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8 > 400
                ? 400
                : MediaQuery.of(context).size.width * 0.8,
            height: 1,
            color: Colors.black12,
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 35,
              ),
              Text(
                'Select a dataset',
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          CustomDropdownBtn(
              onChanged: (String newValue) {
                getProducts(newValue).then((value) {
                  setState(() {
                    currentDataset = newValue;
                    products = value;
                    products.sort((a, b) => a.compareTo(b));
                    widget.onChangeDataset(newValue);
                  });
                });
              },
              value: currentDataset,
              items: datasets
                  .map<DropdownMenuItem<String>>((Map<String, dynamic> value) {
                return DropdownMenuItem<String>(
                  value: value['name'],
                  child: Text(value['name']),
                );
              }).toList()),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 35,
              ),
              Text(
                'Select a product',
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          CustomDropdownBtn(
            value: currentProduct,
            onChanged: (String? newValue) {
              setState(() {
                widget.onChangeProduct(newValue);
                currentProduct = newValue!;
                getTableData(currentProduct, currentDataset).then((value) {
                  setState(() {
                    tableData = value;
                  });
                });
              });
            },
            items: products.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 35,
              ),
              Text(
                'Enter the field to optimize for (e.g. month_year)',
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8 > 400
                ? 400
                : MediaQuery.of(context).size.width * 0.8,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(
                color: Colors.black12,
                width: 1,
              ),
            ),
            child: TextFormField(
              style: GoogleFonts.roboto(
                color: const Color.fromARGB(255, 66, 65, 65),
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: 'Optimization field',
                hintStyle: GoogleFonts.roboto(
                  color: const Color.fromARGB(255, 66, 65, 65),
                  fontSize: 15,
                ),
                border: InputBorder.none,
              ),
              onChanged: (String value) {
                setState(() {
                  widget.onChangeField(value);
                  field = value;
                });
              },
              initialValue: field,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 35,
              ),
              Text(
                'Enter the value to optimize for',
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8 > 400
                ? 400
                : MediaQuery.of(context).size.width * 0.8,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(
                color: Colors.black12,
                width: 1,
              ),
            ),
            child: TextFormField(
              style: GoogleFonts.roboto(
                color: const Color.fromARGB(255, 66, 65, 65),
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: 'Optimization value',
                hintStyle: GoogleFonts.roboto(
                  color: const Color.fromARGB(255, 66, 65, 65),
                  fontSize: 15,
                ),
                border: InputBorder.none,
              ),
              onChanged: (String value) {
                setState(() {
                  widget.onChangeValue(value);
                  this.value = value;
                });
              },
              initialValue: value,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8 > 400
                ? 400
                : MediaQuery.of(context).size.width * 0.8,
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(255, 0, 119, 231),
            ),
            child: TextButton(
              onPressed: widget.enabled
                  ? () {
                      widget.onOptimize(
                          currentProduct, field, value, currentDataset);
                    }
                  : null,
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                overlayColor: MaterialStateProperty.all(
                  Colors.black.withOpacity(0.1),
                ),
              ),
              child: Text(
                'Optimize price',
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showGraphDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text('Price History'),
        content: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width * 0.8 > 700
              ? 700
              : MediaQuery.of(context).size.width * 0.8,
          height: 325,
          child: SfCartesianChart(
            crosshairBehavior: CrosshairBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
            ),
            primaryXAxis: const CategoryAxis(),
            series: <LineSeries<DataObject, String>>[
              LineSeries<DataObject, String>(
                dataSource: tableData,
                xValueMapper: (DataObject sales, _) => sales.monthYear,
                yValueMapper: (DataObject sales, _) => sales.unitPrice,
              )
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
