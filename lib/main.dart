import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:default_project/data/repositories/auth_repository.dart';
import 'package:default_project/data/repositories/categories_repository.dart';
import 'package:default_project/data/repositories/order_repository.dart';
import 'package:default_project/data/repositories/product_repository.dart';
import 'package:default_project/data/repositories/profile_repository.dart';
import 'package:default_project/ui/auth/auth_page.dart';
import 'package:default_project/ui/tab_box/tab_box.dart';
import 'package:default_project/view_models/auth_view_model.dart';
import 'package:default_project/view_models/categories_view_model.dart';
import 'package:default_project/view_models/orders_view_model.dart';
import 'package:default_project/view_models/products_view_model.dart';
import 'package:default_project/view_models/profile_view_model.dart';
import 'package:default_project/view_models/tab_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.subscribeToTopic("users");

  var fireStore = FirebaseFirestore.instance;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TabViewModel()),
        ChangeNotifierProvider(
          create: (context) => CategoriesViewModel(
            categoryRepository: CategoryRepository(
              firebaseFirestore: fireStore,
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductViewModel(
            productRepository: ProductRepository(
              firebaseFirestore: fireStore,
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => OrdersViewModel(
            ordersRepository: OrdersRepository(
              firebaseFirestore: fireStore,
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileViewModel(
              firebaseAuth: FirebaseAuth.instance,
              profileRepository:
                  ProfileRepository(firebaseFirestore: fireStore)),
        ),
        Provider(
          create: (context) => AuthViewModel(
            authRepository: AuthRepository(firebaseAuth: FirebaseAuth.instance),
          ),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData) {
            return const TabBox();
          } else {
            return const AuthPage();
          }
        });
  }
}
