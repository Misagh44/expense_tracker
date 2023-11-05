import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  // creat cerdentials
  static const _credentials = r'''{
  "type": "service_account",
  "project_id": "flutter-gsheets-403909",
  "private_key_id": "d3aeb21f371f14288ada1314e6866360e045bd97",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCwrv05usymrwSh\nV666VzMrwcPvJ6bbe/94UQ4La8vaI1b+LlbXhhg37YUHA/7C0zIPgDbIAZcIW3lr\nw9EY4eVtPamZLIH+Omie8/Pnl0EQ6JRV8gT9KEe3zG2NYrElJrwt+/yEBMoxHo2w\nb6kjyGMND0YWe80tnk/dldnE0zN/PLMz3J68huxXjYqNFHAqt8C/7uocHX96IVns\nKQHOIRjHpHsi5ZKqPAPl1Jpby+7N+6uK+nmUR7NOnR38k0CKveI4gHqvwBsorn8u\nn+ewo71VFeVwzhj/O/3Ir4e/mi/9hA5KQ42hLEV7Y0FT2yfVbYnvTItGPgk58WPM\nPuBCl23BAgMBAAECggEAP3He6ZOL+JDhc0RmsHAuplhSkPbmomsQ7jYA+pXvYjoN\ne4HNWmBDIxYuDjpfibtH/yv1v/VeNDiQzeNHmw1HEuaxF5lVZqK3vdhxLajxSu6R\nkZkyNGv58OS+NCaL4QDbUxHo98k2h9PmYkR+cqR6+Q4Sh3FWWLrACBxO0jBbDiV3\nlNlZmMvZ/DEMUmKaQt66w6NvQ8w6BGPaRqXFlGxRx/qSgiDKNmyPuFb45c18ljB7\nD37tMg0M/Em9SchYKdI0CspyFZCO+/iPxlsOHid24Ja3MlQKg1J6X+5ubPyzeJv/\nZBTo4iy0GcJikXi4kngav7l0feVWRecfYoottHDdbwKBgQDZ9Rk8BK5q8552xtG1\nZdPczZz+dUjSw7qzUFAAYGLgQY7BhoksXhjqf+x1+hPOeV6aQgb6bOA+1aqYS+Tm\n6mZXraoxQt9/RtWFg7IwKFok2cbbWxKJ+qZqRDWea2LamSgzn0FSlktZmKcFrfLj\nEtacaUOtzXr0SDs7ZRmq+V0c+wKBgQDPharguR/c3o6ZYVAIKsp+d1MRt5PkX+C+\nssc5C9zn3WIfRR2BDL9UPST5sWndbDwQj9PfOABeQA7N8qDOtKRXlXnZ99POCnXi\nRnRrvKMywog7v5jhh6TTQNlftJhGOBibDrFD5tw4FlX0FSIA8aQSV6dRmkS7EQ7W\npvNA0ivrcwKBgQDNL8mG0B1nQFvhE8Ee1XMDPmpavw1EpdDguG3oPNU4q176X25J\n33fzY2S3mCsHSQk/jYNGRDND1CCa6W/f17FrP2mmoH8JMiUXYWjhn0tlv8NOhElK\nrjX2eqpDrnLMujy3hGiZmDXtbiFm3mB3VyfE7fAx8eybhliEzOPCKql2+wKBgA7a\nn3+UYK57k7Nw3rym63Wf7uc+v6xCHKEpxM7VhYtnMkXQuarqEavi8Ima5FwAClCZ\nKu44YPZeGXEuY8pH7deDEITEk3mVEBkRN/YaO4g/mmbEcRn7jpW8d5K9J4UnMMOw\niom0taCiIKbm+Fce9MKHWaeipjbJoslEi/bg1Fn3AoGBAJi3ZOBFzpb/FGNfoMXA\nrJW7LPRUTYd7Gtdlzcjja3KZhNpRjCBSZcnLJhQgPWiIug23L1Unz6HtpB8rGfU8\nZthmn+Y0n52i1Ct+PNncQTH9H0u16hIUHbkQIhk5C1gB8ap0ENWaDr3nAvn7k7h1\nk+Q7c+QdDOAPplg/RwVuwuw2\n-----END PRIVATE KEY-----\n",
  "client_email": "flutter-gsheets-tutorial@flutter-gsheets-403909.iam.gserviceaccount.com",
  "client_id": "107795439682819768024",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/flutter-gsheets-tutorial%40flutter-gsheets-403909.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}''';

  // set up & connect to spred sheets
  static final _spreadSheetId = '1Zypp3Gb1IJB7k20q1Q7uszOhS3tmLOanV7nNGy-MVAw';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  static int numberOfTransactions = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;
  static Stopwatch stopwatch = new Stopwatch();

  Future init() async {
    stopwatch.start();
    print('first step executed in ${stopwatch.elapsed}');
    final ss = await _gsheets.spreadsheet(_spreadSheetId);
    _worksheet = ss.worksheetByTitle("Expense");

    countRow();

    ///
    ///
  }

  static Future countRow() async {
    print('second step executed in ${stopwatch.elapsed}');

    while ((await _worksheet!.values
            .value(column: 1, row: numberOfTransactions + 1)) !=
        "") {
      numberOfTransactions++;
    }
    loadTransaction();
  }

  static Future loadTransaction() async {
    print('third step executed in ${stopwatch.elapsed}');

    if (_worksheet == null) return;

    for (int i = 0; i < numberOfTransactions; i++) {
      final String transactionName =
          await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionamount =
          await _worksheet!.values.value(column: 2, row: i + 1);
      final bool transactionType =
          (await _worksheet!.values.value(column: 3, row: i + 1)) == "income"
              ? true
              : false;

      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions
            .add([transactionName, transactionamount, transactionType]);
      }
    }
    print('forth step executed in ${stopwatch.elapsed}');

    loading = false;
  }

  static Future insert(String name, String amount, bool isExpense) async {
    if (_worksheet == null) return;

    numberOfTransactions++;
    currentTransactions.add([name, amount, isExpense]);
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
}
