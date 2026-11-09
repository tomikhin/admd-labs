import 'package:flutter/material.dart';
import 'models/user.dart';
import 'models/bank_account.dart';
import 'models/library_item.dart';
import 'models/book.dart';
import 'models/magazine.dart';
import 'models/library.dart';
import 'screens/todo_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const TodoScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    
    final List<User> users = [
      User(name: 'Alice Smith', age: 22, email: 'alice@example.com'),
      User(name: 'Bob Johnson', age: 25), // email is null
      User(name: 'Charlie Brown') // age and email are null
    ];
    
    final List<BankAccount> accounts = [
      BankAccount(holderName: 'John Doe', balance: 1500.0, bankBranch: 'Main Branch'),
      BankAccount(holderName: 'Jane Smith', balance: 300.0),
    ];
    accounts[0].initializeAccount('RO12REVOLUT3000');

    final Library library = Library();
    library.addItem(Book(title: 'Dart Guide', author: 'Author A', pageCount: 300));
    library.addItem(Magazine(title: 'Tech Monthly', issueNumber: 42));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Task I: Users', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ...users.map((user) => ListTile(
                title: Text(user.name),
                subtitle: Text('Email: ${user.email ?? 'Not provided'}'),
                trailing: Text('Age: ${user.getDisplayAge()}'),
              )),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Task II: Bank Accounts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ...accounts.map((acc) => ListTile(
                title: Text(acc.holderName),
                subtitle: Text('Branch: ${acc.bankBranch ?? 'N/A'} | Balance: \$${acc.balance}'),
                trailing: Text(
                  acc.isAccountNumberSet() ? 'Acc: ${acc.accountNumber}' : 'Uninitialized account',
                  style: TextStyle(
                    color: acc.isAccountNumberSet() ? Colors.green : Colors.red,
                  ),
                ),
              )),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Task III: Library Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ...library.items.map((item) => ListTile(
                title: Text(item.title),
                subtitle: Text('Author: ${item.author ?? 'Unknown'}'),
                trailing: Text(item.borrower == null ? 'Available' : 'Borrowed'),
              )),
        ],
      ),
    );
  }
}
