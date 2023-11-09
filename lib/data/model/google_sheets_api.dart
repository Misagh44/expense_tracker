import 'package:gsheets/gsheets.dart';

import 'google_id.dart';

class GoogleSheetsApi {
  // creat cerdentials

  static final _gsheets = GSheets(GoogleId().credentials);
  static Worksheet? _worksheet;

  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;
  static Stopwatch stopwatch = new Stopwatch();

  Future init() async {
    stopwatch.start();
    print('first step executed in ${stopwatch.elapsed}');
    final ss = await _gsheets.spreadsheet(GoogleId().spreadSheetId);
    _worksheet = ss.worksheetByTitle("Expense");

    // countRow();
    ///
    getDataByRow();

    ///
  }

  static Future insert(String name, String amount, bool isExpense) async {
    if (_worksheet == null) return;

    currentTransactions.insert(0, [name, amount, isExpense]);
    await _worksheet!.values
        .appendRow([name, amount, isExpense ? 'income' : 'expense']);
  }

  static int tutalIncome = 0;
  static int tutalExpense = 0;
  static int balance = 0;
  static void calculateIncomeAndExpenseAndBalance() {
    tutalExpense = 0;
    tutalIncome = 0;
    balance = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == true) {
        tutalIncome += int.parse(currentTransactions[i][1]);
      } else {
        tutalExpense += int.parse(currentTransactions[i][1]);
      }
    }
    balance = tutalIncome - tutalExpense;
  }

  static Future getDataByRow() async {
    if (_worksheet == null) return;

    // final WorksheetAsCells worksheetAsCells = _worksheet!.cells;
    final List<List<String>> allColums = await _worksheet!.values.allColumns();
    print('second step executed in ${stopwatch.elapsed}');
    // print(" number of clolumn :${number.toString()}  ");
    // print(" work sheet as sell :${worksheetAsCells.toString()}  ");
    print(" all colums :${allColums[0].length.toString()}  ");

    for (int i = 0; i < allColums[0].length; i++) {
      final String transactionName = allColums[0][i];
      final String transactionamount = allColums[1][i];
      final bool transactionType = (allColums[2][i]) == "income" ? true : false;

      if (currentTransactions.length < allColums[0].length) {
        currentTransactions
            .add([transactionName, transactionamount, transactionType]);
      }
    }
    print('third step executed in ${stopwatch.elapsed}');
    currentTransactions = currentTransactions.reversed.toList();

    loading = false;
    stopwatch.stop();
  }
}
