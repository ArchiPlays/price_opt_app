import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeWidget extends StatelessWidget {
  final Function showGraphDialog;
  const WelcomeWidget({super.key, required this.showGraphDialog});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 35,
            ),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                text: 'Welcome, ',
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontSize: 27,
                  fontWeight: FontWeight.w300,
                ),
              ),
              TextSpan(
                text: 'John',
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ])),
            const Spacer(),
            // Graph button
            IconButton(
              onPressed: () {
                showGraphDialog();
              },
              icon: const Icon(
                Icons.auto_graph_rounded,
                size: 30,
              ),
              tooltip: 'View price history graph',
            ),
            const SizedBox(
              width: 15,
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
              'Store Manager - Grocery Store A',
              style: GoogleFonts.roboto(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
