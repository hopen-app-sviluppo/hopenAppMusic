import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music/provider/settings_provider.dart';
import 'package:music/provider/user_provider.dart';
import 'package:music/responsive_widget/size_config.dart';
import 'package:music/router.dart';
import 'package:provider/provider.dart';
import './provider/authentication_provider.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //* APP funzionerà solo in portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
//* ottengo le dimensioni dello schermo su cui gira l'app
  final _mediaQueryData =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  final sizeConfig = SizeConfig(_mediaQueryData);
  //* settings provider sarà utile per la lingua (internazionalizzazione dell'app), per la dimensioni delle icone- testi- e altro che dipendono dalla dimensione dello schermo
  //runApp(DevicePreview(enabled: true,builder: (context) => ChangeNotifierProvider<SettingsProvider>(create: (context) => SettingsProvider(sizeConfig),child: const MyApp(),),),);
  runApp(
    ChangeNotifierProvider<SettingsProvider>(
      create: (context) => SettingsProvider(sizeConfig),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (_) => AuthenticationProvider(),
        ),
        //* ogni volta che builda authenticationProvider, aggiorno l'utente
        ChangeNotifierProxyProvider<AuthenticationProvider, UserProvider>(
          create: (_) => UserProvider(null),
          update: (_, authProv, __) => UserProvider(authProv.currentUser),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MT App',
        theme: context.read<SettingsProvider>().currentTheme,
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: AppRouter.initialPage,
      ),
    );
  }
}
