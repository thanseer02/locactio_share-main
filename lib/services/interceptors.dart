// ignore_for_file: empty_catches

import 'dart:convert';

import 'package:base_project/utils/app_build_methods.dart';
import 'package:base_project/widgets/draggable_parent_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class LoggerStackTrace {
  const LoggerStackTrace._({
    required this.functionName,
    required this.callerFunctionName,
    required this.fileName,
    required this.lineNumber,
    required this.columnNumber,
  });

  factory LoggerStackTrace.from(StackTrace trace) {
    final frames = trace.toString().split('\n');
    final functionName = _getFunctionNameFromFrame(frames[0]);
    final callerFunctionName = _getFunctionNameFromFrame(frames[1]);
    final fileInfo = _getFileInfoFromFrame(frames[0]);

    return LoggerStackTrace._(
      functionName: functionName,
      callerFunctionName: callerFunctionName,
      fileName: fileInfo[0],
      lineNumber: int.parse(fileInfo[1]),
      columnNumber: int.parse(fileInfo[2].replaceFirst(')', '')),
    );
  }

  final String functionName;
  final String callerFunctionName;
  final String fileName;
  final int lineNumber;
  final int columnNumber;

  static List<String> _getFileInfoFromFrame(String trace) {
    final indexOfFileName = trace.indexOf(RegExp('[A-Za-z]+.dart'));
    final fileInfo = trace.substring(indexOfFileName);

    return fileInfo.split(':');
  }

  static String _getFunctionNameFromFrame(String trace) {
    final indexOfWhiteSpace = trace.indexOf(' ');
    final subStr = trace.substring(indexOfWhiteSpace);
    final indexOfFunction = subStr.indexOf(RegExp('[A-Za-z0-9]'));

    return subStr
        .substring(indexOfFunction)
        .substring(0, subStr.substring(indexOfFunction).indexOf(' '));
  }

  @override
  String toString() {
    return '('
        'functionName: $functionName, '
        'callerFunctionName: $callerFunctionName, '
        'fileName: $fileName, \t'
        'lineNumber: $lineNumber, \t'
        'columnNumber: $columnNumber)\n';
  }
}

class AppStackInterceptor extends Interceptor {
  AppStackInterceptor({this.onDisplayLog}) : super();
  final ValueChanged<String>? onDisplayLog;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      _displayLog('\n\n\n*********** REQUEST ************\n');
      _displayRequestOption(options);
    } on Exception {}
    handler.next(options);
  }

  void _displayRequestOption(RequestOptions options) {
    _displayLog('URL: ${options.method} ${options.uri}');
    _displayLog('\n');
    _displayLog('\n');

    _displayLog('HEADERS: ${jsonEncode(options.headers)}');
    _displayLog('\n');

    if (options.data != null) {
      if (options.data is FormData) {
      } else if (options.data is Map) {
        _displayLog('DATA: ${jsonEncode(options.data as Map)}');
      } else {
        _displayLog('DATA: ${options.data}');
      }
    }
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    try {
      _displayLog('\n\n\n************ RESPONSE ***********\n');

      _displayResponse(response);
    } on Exception {}
    handler.next(response);
  }

  void _displayResponse(Response<dynamic> response) {
    _displayLog('URL: ${response.requestOptions.method} ${response.realUri}');
    _displayLog('\n');
    _displayLog('\n');
    _displayLog('RESPONSE: ${response.data}');
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    try {
      _displayLog('\n\n\n************ ERROR ***********\n');
      _displayRequestOption(err.requestOptions);
      _displayLog('\n');
      _displayLog(err.message ?? '');
      _displayLog('\n');

      if (err.response != null) {
        _displayResponse(err.response!);
      }
    } on Exception {}
    handler.next(err);
  }

  void _displayLog(String val) {
    (onDisplayLog ?? (_) {})(val);
  }
}

class AppStackInterceptorBuilder extends StatefulWidget {
  const AppStackInterceptorBuilder({required this.child, super.key});
  static final ValueNotifier<String> _logNotfier = ValueNotifier('');

  static AppStackInterceptor appStackInterceptor = AppStackInterceptor(
    onDisplayLog: addToNotifier,
  );

  final Widget child;
  @override
  State<AppStackInterceptorBuilder> createState() =>
      _AppStackInterceptorBuilderState();

  static void addToNotifier(String value) {
    _logNotfier.value += value;
  }
}

class _AppStackInterceptorBuilderState
    extends State<AppStackInterceptorBuilder> {
  final _scrollController = ScrollController();

  final ValueNotifier<bool> _isExpandedNotifier = ValueNotifier(false);

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          widget.child,
          Positioned.fill(
            child: ValueListenableBuilder<bool>(
              valueListenable: _isExpandedNotifier,
              builder: (context, isExpanded, _) {
                this.isExpanded = isExpanded;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (isExpanded)
                      Expanded(
                        child: SafeArea(
                          left: false,
                          child: ColoredBox(
                            color: Colors.black.withOpacity(0.5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextButton(
                                        onPressed: () =>
                                            AppStackInterceptorBuilder
                                                ._logNotfier.value = '',
                                        style: TextButton.styleFrom(
                                          // primary: Colors.green,
                                          textStyle: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        child: const Text('Clear All'),
                                      ),
                                      TextButton(
                                        onPressed: _onClick,
                                        style: TextButton.styleFrom(
                                          // primary: Colors.green,
                                          textStyle: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        child: const Text('Copy'),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    controller: _scrollController,
                                    child: ValueListenableBuilder<String>(
                                      valueListenable:
                                          AppStackInterceptorBuilder
                                              ._logNotfier,
                                      builder: (context, log, _) => Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.0.sp,
                                        ),
                                        child: SelectableText(
                                          log,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          DraggIt(
            initialPosition: AnchoringPosition.bottomLeft,
            child: InkWell(
              onTap: _onTapExpand,
              child: Padding(
                padding: const EdgeInsets.all(50),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFe0f2f1),
                  ),
                  padding: const EdgeInsets.all(5),
                  child: AnimatedIcon(
                    icon: AnimatedIcons.play_pause,
                    progress:
                        AlwaysStoppedAnimation<double>(isExpanded ? 1.0 : 0.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onClick() async {
    await Clipboard.setData(
      ClipboardData(text: AppStackInterceptorBuilder._logNotfier.value),
    );
    showToast('copied');
  }

  void _onTapExpand() {
    _isExpandedNotifier.value = !_isExpandedNotifier.value;
    if (_isExpandedNotifier.value) {
      try {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 350),
            curve: Curves.ease,
          ),
        );
      } on Exception {}
    }
  }
}
