import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDropdownBtn extends StatelessWidget {
  final Function onChanged;
  final String value;
  final List<DropdownMenuItem<String>> items;
  const CustomDropdownBtn(
      {super.key,
      required this.onChanged,
      required this.value,
      required this.items});

  @override
  Widget build(BuildContext context) => DropdownButtonHideUnderline(
        child: Container(
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
          child: DropdownButton<String>(
            value: value,
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: GoogleFonts.roboto(
                color: const Color.fromARGB(255, 66, 65, 65)),
            onChanged: (String? newValue) {
              onChanged(newValue!);
            },
            items: items,
          ),
        ),
      );
}
