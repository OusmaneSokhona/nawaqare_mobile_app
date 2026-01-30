import 'package:flutter/material.dart';

class DisplayFieldContainer extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const DisplayFieldContainer({
    super.key,
    required this.label,
    required this.value,this.valueColor=Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return value.isNotEmpty&&value!=null ?Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          width: double.infinity, // Take up the full width available
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: Text(
            value,
            style:  TextStyle(
              fontSize: 16,
              color:valueColor,
              fontWeight: FontWeight.normal,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    ):SizedBox();
  }
}