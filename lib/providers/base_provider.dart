import 'dart:io';

import 'package:ODMGear/providers/mixin_progress_provider.dart';
import 'package:ODMGear/utils/extensions.dart';
import 'package:flutter/material.dart';


/// A callback for showing error messages
typedef OnShowError = void Function(String msg, {bool? asToast});

/// An abstract base class for implementing providers.
abstract class BaseProvider extends ChangeNotifier with MixinProgressProvider {
  /// The default constructor
  BaseProvider({String? name})
      : _providerName = name,
        super();
  final String? _providerName;

  /// Network status of the application.
  bool hasNetwork = false;

  /// Getter method for [_providerName].
  String? get providerName => _providerName;

  /// Returns an integer indicating the platform
  /// 1 - Android, 2 - iOS, -1 - Other
  int get deviceType {
    if (Platform.isAndroid) return 1;
    if (Platform.isIOS) return 2;
    return -1;
  }

  @override
  void notifyListeners() {
    try {
      super.notifyListeners();
    } catch (ex) {
      ex.log();
    }
  }
}

/// The base api for list pagination
/// The [IM] can be the interface model
abstract class BaseListLoadMoreProvider<IM> extends BaseProvider {
  BaseListLoadMoreProvider({int limit = 5, String? name})
      : _limit = limit,
        super(name: name ?? 'BaseListLoadMoreProvider');
  final int _limit;
  final _list = <IM>[];
  int _offset = 0;
  int _page = 1;
  bool _isAllCompleted = false;

  List<IM> get list => _list;

  int get limit => _limit;

  int get offset => _offset;

  int get page => _page;

  bool get canLoadMore => (!_isAllCompleted) && (!super.isLoading);

  // ignore: avoid_setters_without_getters
  set _addToList(List<IM>? value) {
    if (value?.isNotEmpty ?? false) {
      ///uncomment clear to the current list and append next page
      _list
        ..clear()
        ..addAll(value!);
    }
    notifyListeners();
  }

  Future<List<IM>> fetchAPIService();

  // Future<List<IM>> fetchAPIService();
  Future<ListLoadOptionModel<IM>?> fetchListData({
    required OnShowError onShowError,
    ValueChanged<List<IM>?>? onSuccess,
    VoidCallback? onInit,
  }) async {
    if (super.isLoading) return null;
    super.isLoading = true;
    if (onInit != null) {
      onInit();
    }
    await fetchAPIService().then((models) {
      _isAllCompleted = models.length < _limit;
      _offset += models.length;
      _addToList = models;
      _page++;
      if (onSuccess != null) onSuccess(models);
      return models;
    }).whenComplete(() => super.isLoading = false);
    return null;
  }

  void reset() {
    _offset = 0;
    _page = 1;
    _isAllCompleted = false;
    _list.clear();
  }
}

class ListLoadOptionModel<IM> {
  ListLoadOptionModel({
    required this.totalCount,
    required this.pageCount,
    required this.currentPage,
    required this.perPage,
    required this.iList,
  });
  int? totalCount;
  int? pageCount;
  int? currentPage;
  int? perPage;

  List<IM>? iList;
}
