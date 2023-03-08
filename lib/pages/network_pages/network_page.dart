//import 'dart:async';
//import 'dart:io';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:music/pages/common_widget/error_page.dart';
//import 'package:music/pages/network_pages/network_provider.dart';
//import 'package:music/provider/user_provider.dart';
//import 'package:music/theme.dart';
//import 'package:provider/provider.dart';
//import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music/theme.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../provider/user_provider.dart';
import 'network_provider.dart';

//// Import for Android features.
//import 'package:webview_flutter_android/webview_flutter_android.dart';
//// Import for iOS features.
//import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
//
//class NetworkPage extends StatefulWidget {
//  const NetworkPage({
//    Key? key,
//  }) : super(key: key);
//
//  @override
//  State<NetworkPage> createState() => _NetworkPageState();
//}
//
//class _NetworkPageState extends State<NetworkPage> {
//  late final WebViewController _controller;
//  bool showError = false;
//  final cookieManager = WebViewCookieManager();
//
//  @override
//  void initState() {
//    super.initState();
//    late final PlatformWebViewControllerCreationParams params;
//    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
//      params = WebKitWebViewControllerCreationParams(
//        allowsInlineMediaPlayback: true,
//        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
//      );
//    } else {
//      params = const PlatformWebViewControllerCreationParams();
//    }
//
//    final WebViewController controller =
//        WebViewController.fromPlatformCreationParams(params);
//    // #enddocregion platform_features
//
//    controller
//      ..setJavaScriptMode(JavaScriptMode.unrestricted)
//      ..setBackgroundColor(MainColor.primaryColor)
//      ..setNavigationDelegate(
//        NavigationDelegate(
//          onProgress: (int progress) {
//            print('WebView is loading (progress : $progress%)');
//          },
//          onPageStarted: (String url) async {
//            print('Page started loading: $url');
//            await controller.runJavaScript(
//                'document.cookie = "token=${context.read<UserProvider>().currentUser!.internalAccount.token}"');
//            cookieManager.setCookie(WebViewCookie(
//                name: "token",
//                value: context
//                    .read<UserProvider>()
//                    .currentUser!
//                    .internalAccount
//                    .token,
//                domain: url));
//          },
//          //  onPageFinished: (String url) async {
//          //    //   await controller.runJavaScript(
//          //    //       'document.cookie = "token=${context.read<UserProvider>().currentUser!.internalAccount.token}"');
//          //    // cookieManager.setCookie(WebViewCookie(
//          //    //     name: "token",
//          //    //     value: context
//          //    //         .read<UserProvider>()
//          //    //         .currentUser!
//          //    //         .internalAccount
//          //    //         .token,
//          //    //     domain: url));
//          //    print('Page finished loading: $url');
//          //  },
//          onWebResourceError: (WebResourceError error) {
//            //mostro pagina di errore
//            context.read<NetworkProvider>().uploadError(true);
//          },
//          //onNavigationRequest: (NavigationRequest request) {
//          //  if (request.url.startsWith('https://www.youtube.com/')) {
//          //    debugPrint('blocking navigation to ${request.url}');
//          //    return NavigationDecision.prevent;
//          //  }
//          //  debugPrint('allowing navigation to ${request.url}');
//          //  return NavigationDecision.navigate;
//          //},
//        ),
//      )
//      ..addJavaScriptChannel(
//        'Toaster',
//        onMessageReceived: (JavaScriptMessage message) {
//          ScaffoldMessenger.of(context).showSnackBar(
//            SnackBar(content: Text(message.message)),
//          );
//        },
//      );
//    //..loadRequest(Uri.parse("https://hopennetwork.it"));
//    // final ciao = context
//    //     .read<UserProvider>()
//    //     .currentUser!
//    //     .socialAccount
//    //     .cookies['set-cookie']!
//    //     .split(";");
//    // print("ecco la lista ciao: $ciao");
//    // // final Map<String, String> cookie = {'Cookie': ciao[0]};
//    // //print("ecco response: $cookie");
//    // Cookie co = Cookie("ad-con", ciao[3]);
//
//    // #docregion platform_features
//    if (controller.platform is AndroidWebViewController) {
//      AndroidWebViewController.enableDebugging(true);
//      (controller.platform as AndroidWebViewController)
//          .setMediaPlaybackRequiresUserGesture(false);
//    }
//    // #enddocregion platform_features
//
//    _controller = controller;
//  }
//
////! APP BAR STA su initial_pages/main_page
//  //     //TODO: problema: la prima volta mi rimanda su login => dovrei andare dritto per dritto sul social, senza rifare il login
//  //! GUIDA UTILE: https://stackoverflow.com/questions/73785137/pass-auth-cookie-to-webview-flutter
//  @override
//  Widget build(BuildContext context) {
//    //return SafeArea(child: WebViewWidget(controller: _controller));
//    return Scaffold(
//      body: SafeArea(
//          child: FutureBuilder(
//        future: _controller.loadRequest(
//          Uri.parse("https://hopennetwork.it"),
//          //headers: {'PHPSESSID': "5591cuaar5taklq1rborsq7nh7"},
//        ),
//        //mi entra ma come ospite
//        //  "https://hopennetwork.it/${context.read<UserProvider>().currentUser!.socialAccount.username}?token=${context.read<UserProvider>().currentUser!.internalAccount.token}")),
//        builder: (context, snap) {
//          if (snap.connectionState == ConnectionState.waiting) {
//            return const Center(
//              child: CircularProgressIndicator(),
//            );
//          }
//          if (snap.hasError) {
//            return ErrorPage(
//              error: "Errore indesiderato",
//              btnText: "Torna alla Home",
//              onBtnPressed: () => Navigator.of(context).pop(),
//            );
//          }
//
//          return Consumer<NetworkProvider>(
//            builder: (context, prov, _) {
//              if (prov.showError) {
//                return ErrorPage(
//                  error: "Errore indesiderato",
//                  btnText: "Torna alla Home",
//                  onBtnPressed: () => Navigator.of(context).pop(),
//                );
//              }
//              return WebViewWidget(controller: _controller);
//            },
//          );
//        },
//      )),
//    );
//  }
//}

class NetworkPage extends StatefulWidget {
  const NetworkPage({
    Key? key,
  }) : super(key: key);

  @override
  State<NetworkPage> createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage> {
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: WebView(
      onWebResourceError: (error) {
        print("ecco errror: $error");
        //context.read<NetworkProvider>().uploadError(true);
      },
      backgroundColor: MainColor.primaryColor,
      javascriptMode: JavascriptMode.unrestricted,
      initialUrl: "https://hopennetwork.it",
      initialCookies: [
        WebViewCookie(
          name: "token",
          value:
              context.read<UserProvider>().currentUser!.internalAccount.token,
          domain: "https://hopennetwork.it",
        ),
      ],
    )));
  }
}
