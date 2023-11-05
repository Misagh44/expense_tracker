import 'package:flutter/material.dart';

class Transection extends StatelessWidget {
  final String transActionName;
  final String amount;
  final bool isIncom;

  const Transection(
      {required this.transActionName,
      required this.amount,
      required this.isIncom});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(10.0),
            color: Colors.grey.shade200,
            height: 50,
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 38,
                      width: 38,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade500,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              offset: Offset(4.0, 4.0),
                              blurRadius: 15.0,
                              spreadRadius: 1.0,
                            ),
                            BoxShadow(
                              color: Colors.grey.shade100,
                              offset: Offset(-4.0, -4.0),
                              blurRadius: 15.0,
                              spreadRadius: 1.0,
                            )
                          ]),
                      child: Icon(
                        Icons.attach_money,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: Text(transActionName),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Text(
                    (isIncom ? "+ \$" : "- \$") + amount,
                    style: TextStyle(
                        color: isIncom ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )),
          ),
        ),
        SizedBox(
          height: 8,
        )
      ],
    );
  }
}
