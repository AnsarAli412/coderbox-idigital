/*
import 'dart:async';
import 'package:idigital_costumer/Helper/Color.dart';
import 'package:idigital_costumer/Provider/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../Helper/Constant.dart';
import '../../Helper/routes.dart';
import '../../widgets/desing.dart';
import '../Language/languageSettings.dart';
import '../../widgets/snackbar.dart';

class MidTrashWebview extends StatefulWidget {
  final String? url, from, msg, amt, orderId;

  const MidTrashWebview(
      {Key? key, this.url, this.from, this.msg, this.amt, this.orderId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StateMidTrashWebview();
  }
}

class StateMidTrashWebview extends State<MidTrashWebview> {
  String message = '';
  bool isloading = true;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  DateTime? currentBackPressTime;
  late UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        titleSpacing: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return Container(
              margin: const EdgeInsets.all(10),
              decoration: DesignConfiguration.shadow(),
              child: Card(
                elevation: 0,
                child: InkWell(
                  borderRadius: BorderRadius.circular(circularBorderRadius4),
                  onTap: () {
                    DateTime now = DateTime.now();
                    if (currentBackPressTime == null ||
                        now.difference(currentBackPressTime!) >
                            const Duration(seconds: 2)) {
                      currentBackPressTime = now;
                      setSnackbar(
                        "${getTranslated(context, "Don't press back while doing payment!")}\n ${getTranslated(context, 'EXIT_WR')!}",
                        context,
                      );
                    }
                    Routes.pop(context);
                  },
                  child: const Center(
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      color: colors.primary,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        title: Text(
          appName,
          style: TextStyle(
            fontFamily: 'ubuntu',
            color: Theme.of(context).colorScheme.fontColor,
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Stack(
          children: <Widget>[
            WebView(
              initialUrl: widget.url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              navigationDelegate: (NavigationRequest request) async {
                if (request.url
                    .contains('app/v1/api/midtrans_payment_process')) {
                  if (mounted) {
                    setState(
                      () {
                        isloading = true;
                      },
                    );
                  }
                  String responseurl = request.url;
                  if (responseurl.contains('Failed') ||
                      responseurl.contains('failed')) {
                    if (mounted) {
                      setState(
                        () {
                          isloading = false;
                        },
                      );
                    } else if (responseurl.contains('capture') ||
                        responseurl.contains('completed') ||
                        responseurl.toLowerCase().contains('success')) {}
                  }
                  Navigator.of(context).pop();

                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
              onPageFinished: (String url) {
                setState(
                  () {
                    isloading = false;
                  },
                );
              },
            ),
            isloading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(),
            message.trim().isEmpty
                ? Container()
                : Center(
                    child: Container(
                      color: colors.primary,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.all(5),
                      child: Text(
                        message,
                        style: TextStyle(
                          fontFamily: 'ubuntu',
                          color: Theme.of(context).colorScheme.white,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      setSnackbar(
        "${getTranslated(context, "Don't press back while doing payment!")}\n ${getTranslated(context, 'EXIT_WR')!}",
        context,
      );
      return Future.value(false);
    }
    Navigator.pop(context, 'true');
    return Future.value(true);
  }
}
*/

import 'dart:async';
import 'package:idigital_costumer/Helper/Color.dart';
import 'package:idigital_costumer/Provider/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../Helper/Constant.dart';
import '../../Helper/routes.dart';
import '../../widgets/desing.dart';
import '../Language/languageSettings.dart';
import '../../widgets/snackbar.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class MidTrashWebview extends StatefulWidget {
  final String? url, from, msg, amt, orderId;

  const MidTrashWebview(
      {Key? key, this.url, this.from, this.msg, this.amt, this.orderId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StateMidTrashWebview();
  }
}

class StateMidTrashWebview extends State<MidTrashWebview> {
  String message = '';
  bool isloading = true;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  /* final Completer<WebViewController> _controller =
  Completer<WebViewController>();*/
  DateTime? currentBackPressTime;
  late UserProvider userProvider;
  late final WebViewController _controller;

  @override
  void initState() {
    // TODO: implement initState
    webViewInitiliased();
    super.initState();
  }

  webViewInitiliased() {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            setState(
              () {
                isloading = false;
              },
            );
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('app/v1/api/midtrans_payment_process')) {
              if (mounted) {
                setState(
                  () {
                    isloading = true;
                  },
                );
              }
              String responseurl = request.url;
              if (responseurl.contains('Failed') ||
                  responseurl.contains('failed')) {
                if (mounted) {
                  setState(
                    () {
                      isloading = false;
                    },
                  );
                } else if (responseurl.contains('capture') ||
                    responseurl.contains('completed') ||
                    responseurl.toLowerCase().contains('success')) {

                }
              }
              Navigator.of(context).pop();

              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(widget.url!));

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        titleSpacing: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return Container(
              margin: const EdgeInsets.all(10),
              decoration: DesignConfiguration.shadow(),
              child: Card(
                elevation: 0,
                child: InkWell(
                  borderRadius: BorderRadius.circular(circularBorderRadius4),
                  onTap: () {
                    DateTime now = DateTime.now();
                    if (currentBackPressTime == null ||
                        now.difference(currentBackPressTime!) >
                            const Duration(seconds: 2)) {
                      currentBackPressTime = now;
                      setSnackbar(
                        "${getTranslated(context, "Don't press back while doing payment!")}\n ${getTranslated(context, 'EXIT_WR')!}",
                        context,
                      );
                    }
                    Routes.pop(context);
                  },
                  child: const Center(
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      color: colors.primary,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        title: Text(
          appName,
          style: TextStyle(
            fontFamily: 'ubuntu',
            color: Theme.of(context).colorScheme.fontColor,
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Stack(
          children: <Widget>[
            WebViewWidget(controller: _controller),
            /* WebView(
              initialUrl: widget.url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              navigationDelegate: (NavigationRequest request) async {
                if (request.url
                    .contains('app/v1/api/midtrans_payment_process')) {
                  if (mounted) {
                    setState(
                      () {
                        isloading = true;
                      },
                    );
                  }
                  String responseurl = request.url;
                  if (responseurl.contains('Failed') ||
                      responseurl.contains('failed')) {
                    if (mounted) {
                      setState(
                        () {
                          isloading = false;
                        },
                      );
                    } else if (responseurl.contains('capture') ||
                        responseurl.contains('completed') ||
                        responseurl.toLowerCase().contains('success')) {}
                  }
                  Navigator.of(context).pop();

                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
              onPageFinished: (String url) {
                setState(
                  () {
                    isloading = false;
                  },
                );
              },
            ),*/
           /* isloading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(),*/
            message.trim().isEmpty
                ? Container()
                : Center(
                    child: Container(
                      color: colors.primary,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.all(5),
                      child: Text(
                        message,
                        style: TextStyle(
                          fontFamily: 'ubuntu',
                          color: Theme.of(context).colorScheme.white,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      setSnackbar(
        "${getTranslated(context, "Don't press back while doing payment!")}\n ${getTranslated(context, 'EXIT_WR')!}",
        context,
      );
      return Future.value(false);
    }
    Navigator.pop(context, 'true');
    return Future.value(true);
  }
}
