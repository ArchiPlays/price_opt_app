import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:optiprice_ai/util/data_object.dart';
import 'package:optiprice_ai/util/get.dart';

class ResultCont extends StatefulWidget {
  final bool loading;
  final Function onLoadingStateChanged;
  final String product;
  final String field;
  final String value;
  final String dataset;
  final Map<String, dynamic> results;

  const ResultCont(
      {super.key,
      required this.product,
      required this.field,
      required this.value,
      required this.loading,
      required this.onLoadingStateChanged,
      required this.results,
      required this.dataset});

  @override
  State<ResultCont> createState() => _ResultContState();
}

class _ResultContState extends State<ResultCont> {
  List<DataObject> tableData = [];

  @override
  void initState() {
    super.initState();
    getTableData(widget.product, widget.dataset).then((value) => setState(() {
          tableData = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.8 > 700
            ? 700
            : MediaQuery.of(context).size.width * 0.8,
        height: 450,
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
              height: 35,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 35,
                ),
                Text(
                  'Results',
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 27,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 35,
                ),
                Text(
                  'Optimizing ${widget.product} for ${widget.field}=${widget.value}',
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            widget.loading
                ? const SizedBox(
                    height: 100,
                  )
                : const SizedBox(
                    height: 30,
                  ),
            widget.loading
                ? const Center(
                    child: SpinKitPulsingGrid(
                      color: Colors.blue,
                      size: 100.0,
                    ),
                  )
                : const SizedBox(),
            widget.loading
                ? const SizedBox(
                    height: 30,
                  )
                : const SizedBox(),
            widget.results.isNotEmpty && !widget.loading
                ? Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            children: [
                              Container(
                                width: 275,
                                height: 110,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: Colors.black12, width: 2),
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Optimized Value',
                                      style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontSize: 21,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    RichText(
                                        text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'USD ',
                                          style: GoogleFonts.roboto(
                                            color: Colors.black,
                                            fontSize: 23,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        TextSpan(
                                          text: double.parse(widget
                                                  .results['message']
                                                  .toString())
                                              .toStringAsFixed(2),
                                          style: GoogleFonts.roboto(
                                            color: Colors.black,
                                            fontSize: 23,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ],
                                    )),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8 >
                                        275
                                    ? 275
                                    : MediaQuery.of(context).size.width * 0.8,
                                height: 50,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color.fromARGB(255, 0, 127, 231),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              backgroundColor: Colors.white,
                                              surfaceTintColor:
                                                  Colors.transparent,
                                              title: const Text('Reasoning'),
                                              content: Container(
                                                color: Colors.white,
                                                width: MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8 >
                                                        350
                                                    ? 350
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.8,
                                                child: Text(
                                                    widget.results['reasoning'],
                                                    style: GoogleFonts.roboto(
                                                      fontSize: 16,
                                                    )),
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () async {
                                                      // copy to clipboard
                                                      await Clipboard.setData(
                                                          ClipboardData(
                                                              text: widget
                                                                      .results[
                                                                  'reasoning']));
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              const SnackBar(
                                                                  content: Text(
                                                                      'Copied to clipboard')));
                                                    },
                                                    child: const Text('Copy')),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Close'),
                                                ),
                                              ],
                                            ));
                                  },
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
                                    'View reasoning',
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
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AnimatedRadialGauge(
                                duration: const Duration(seconds: 1),
                                curve: Curves.easeInOut,
                                radius: 150,
                                value: widget.results['confidence']['overall'],
                                axis: const GaugeAxis(
                                    progressBar: GaugeBasicProgressBar(
                                      color: Color.fromARGB(45, 146, 146, 146),
                                    ),
                                    max: 1,
                                    min: 0.7,
                                    degrees: 180,
                                    segments: [
                                      GaugeSegment(
                                        cornerRadius: Radius.circular(10),
                                        from: 0.7,
                                        to: 0.8,
                                        color: Color.fromARGB(255, 221, 22, 22),
                                      ),
                                      GaugeSegment(
                                        cornerRadius: Radius.circular(10),
                                        from: 0.8,
                                        to: 0.9,
                                        color: Color.fromARGB(255, 255, 153, 0),
                                      ),
                                      GaugeSegment(
                                        cornerRadius: Radius.circular(10),
                                        from: 0.9,
                                        to: 1,
                                        color: Color.fromARGB(255, 26, 202, 32),
                                      ),
                                    ],
                                    style: GaugeAxisStyle(
                                        thickness: 30, segmentSpacing: 10)),
                                // value labels
                                builder: (context, child, value) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Confidence: ',
                                            style: GoogleFonts.roboto(
                                              color: Colors.black,
                                              fontSize: 23,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                '${(value * 100).toStringAsFixed(0)}%',
                                            style: GoogleFonts.roboto(
                                              color: double.parse(
                                                          value.toString()) <
                                                      0.8
                                                  ? Colors.red
                                                  : double.parse(value
                                                              .toString()) <
                                                          0.9
                                                      ? Colors.orange
                                                      : Colors.green,
                                              fontSize: 23,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  RichText(
                                      text: TextSpan(children: [
                                    const TextSpan(text: 'R\u00B2: '),
                                    TextSpan(
                                        text: widget.results['confidence']['r2']
                                            .toStringAsFixed(2),
                                        style: GoogleFonts.roboto(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        )),
                                  ])),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  RichText(
                                      text: TextSpan(children: [
                                    const TextSpan(
                                      text: 'MAE: ',
                                    ),
                                    TextSpan(
                                        text: widget.results['confidence']
                                                ['mae']
                                            .toStringAsFixed(2),
                                        style: GoogleFonts.roboto(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        )),
                                  ])),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 35),
                          const Icon(Icons.info_rounded),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8 > 600
                                ? 600
                                : MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                              'Confidence is a measure of how well the model predicts the value. ${widget.results['improve_confidence']}',
                              maxLines: 4,
                              style: GoogleFonts.roboto(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                : Center(
                    child: Text(
                    widget.loading
                        ? 'Loading...'
                        : 'Click optimize price to generate results',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  )),
          ],
        ));
  }
}
