import 'dart:async';

import 'package:expense_tracker/data/model/google_sheets_api.dart';
import 'package:expense_tracker/presentation/pages/widgets/loading_circle.dart';
import 'package:expense_tracker/presentation/pages/widgets/plus_button.dart';
import 'package:expense_tracker/presentation/pages/widgets/top_card.dart';
import 'package:expense_tracker/presentation/pages/widgets/transection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
// add new transaction
  final _textcontrolerAmount = TextEditingController();
  final _textcontrolerItemName = TextEditingController();
  bool isExpense = false;
  bool isValidAmunt = false;
  bool isValidName = false;

  @override
  Widget build(BuildContext context) {
    if (GoogleSheetsApi.loading == true && timerHasStarted == false) {
      startLoading();
    }
    GoogleSheetsApi.calculateIncomeAndExpenseAndBalance();

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            TopNeuCard(
              balance: '\$${GoogleSheetsApi.balance.toString()}',
              income: '\$${GoogleSheetsApi.tutalIncome.toString()}',
              expance: '\$${GoogleSheetsApi.tutalExpense}',
            ),
            Expanded(
              child: GoogleSheetsApi.loading
                  ? const MyLoadingCircle()
                  : ExpenseList(),
            ),
            PlusButton(onPress: _newTrasAction),
          ],
        ),
      ),
    );
  }

  void _newTrasAction() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.grey.shade300,
              title: const Text(' N E W  T R A N S E A C T I N'),
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Container(
                  height: MediaQuery.of(context).size.height / 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Expense"),
                          Switch(
                            value: isExpense,
                            activeColor: Colors.grey.shade600,
                            inactiveTrackColor: Colors.grey.shade200,
                            thumbColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors.white.withOpacity(.48);
                              }
                              return Colors.grey.shade600;
                            }),
                            onChanged: (value) {
                              setState(() {
                                isExpense = value;
                                print(isExpense);
                              });
                            },
                          ),
                          const Text("Income"),
                        ],
                      ),
                      TextField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9]+"))
                        ],
                        controller: _textcontrolerAmount,
                        style: const TextStyle(color: Colors.black),
                        maxLines: 1,
                        autocorrect: false,
                        maxLength: 32,
                        keyboardType: TextInputType.number,
                        onChanged: (inputValue) {
                          if (inputValue.isEmpty || inputValue == "") {
                            setState(() {
                              isValidAmunt = true;
                            });
                          } else {
                            setState(() {
                              isValidAmunt = false;
                            });
                          }
                        },
                        decoration: InputDecoration(
                            errorText:
                                isValidAmunt ? "please add Amount " : null,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            hintStyle: TextStyle(color: Colors.grey.shade500),
                            hintText: "Amount"),
                      ),
                      TextField(
                        controller: _textcontrolerItemName,
                        style: const TextStyle(color: Colors.black),
                        maxLines: 1,
                        maxLength: 32,
                        keyboardType: TextInputType.name,
                        autocorrect: true,
                        onChanged: (inputValue) {
                          if (inputValue.isEmpty || inputValue == "") {
                            setState(() {
                              isValidName = true;
                            });
                          } else {
                            setState(() {
                              isValidName = false;
                            });
                          }
                        },
                        decoration: InputDecoration(
                            errorText: isValidName ? "please add name " : null,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            hintStyle: TextStyle(color: Colors.grey.shade500),
                            hintText: "name"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FloatingActionButton(
                            backgroundColor: Colors.grey.shade600,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          FloatingActionButton(
                            backgroundColor: Colors.grey.shade600,
                            onPressed: () {
                              if (_textcontrolerAmount.text == "") {
                                setState(() {
                                  isValidAmunt = true;
                                });
                              }
                              if (_textcontrolerItemName.text == "") {
                                setState(() {
                                  isValidName = true;
                                });
                              }
                              if (isValidAmunt || isValidName) {
                                return;
                              }

                              setValidatorAmount(true);
                              _enterTransAction();
                              Navigator.of(context).pop();
                            },
                            child: const Text("Enter",
                                style: TextStyle(color: Colors.white)),
                          )
                        ],
                      )
                    ],
                  ),
                );
              }));
        });
  }

  //wait to load data from google
  bool timerHasStarted = false;
  void startLoading() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (GoogleSheetsApi.loading == false) {
        setState(() {});
        timer.cancel();
      }
    });
  }

  Container ExpenseList() {
    return Container(
      child: Center(
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: GoogleSheetsApi.currentTransactions.length,
                  itemBuilder: ((context, index) {
                    return Transection(
                        transActionName:
                            GoogleSheetsApi.currentTransactions[index][0],
                        amount: GoogleSheetsApi.currentTransactions[index][1],
                        isIncom: GoogleSheetsApi.currentTransactions[index][2]);
                  }))),
        ]),
      ),
    );
  }

  void setValidatorAmount(bool valid) {
    setState(() {
      // isValidAmunt = valid;
    });
  }

  void _enterTransAction() {
    setState(() {});
    GoogleSheetsApi.insert(
        _textcontrolerItemName.text, _textcontrolerAmount.text, isExpense);
  }
}
