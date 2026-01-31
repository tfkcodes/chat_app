import 'package:chat_app/pages/home_screen.dart';
import 'package:chat_app/providers/transaction_provider.dart';
import 'package:chat_app/routes/router_helper.dart';
import 'package:chat_app/services/sms_background_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import 'models/transaction_model.dart';

void main() async {
  debugPrint('App launched Begin');

  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(TransactionModelAdapter());
  await Hive.openBox<TransactionModel>('transaction_queue');

  runApp(const MyApp());

  debugPrint('App launched successfully');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("About to run the app");

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            final provider = TransactionProvider();
            provider.listenToSmsStream();
            return provider;
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          // ✅ Initialize background service with provider
          final provider =
              Provider.of<TransactionProvider>(context, listen: false);
          SmsBackgroundService.initialize(provider: provider);

          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            debugShowCheckedModeBanner: false,
            initialRoute: RouteHelper.getInitial(),
            home: MainPage(),
          );
        },
      ),
    );
  }
}
