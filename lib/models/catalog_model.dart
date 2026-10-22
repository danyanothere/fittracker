import 'package:flutter/foundation.dart';
import '../data/result.dart';
import '../data/exercise_repository.dart';
import 'exercise.dart';

// Состояние каталога: триада loading/data/error + поиск и пагинация ломтями.
class CatalogModel extends ChangeNotifier {
  CatalogModel(this._repository);
  final ExerciseRepository _repository;

  bool _loading = false;
  bool _loadingMore = false;
  String? _error;
  List<Exercise> _exercises = const [];
  String _search = '';
  int _page = 1;
  bool _hasMore = false;
  static const _limit = 10;

  bool get isLoading => _loading;
  bool get isLoadingMore => _loadingMore;
  String? get error => _error;
  String get search => _search;
  bool get hasMore => _hasMore;
  List<Exercise> get exercises => List.unmodifiable(_exercises);

  Exercise? byId(int id) {
    for (final e in _exercises) {
      if (e.id == id) return e;
    }
    return null;
  }

  Future<void> load({String? search}) async {
    _search = search ?? _search;
    _page = 1;
    _loading = true;
    _error = null;
    notifyListeners();
    switch (await _repository.fetchAll(page: _page, limit: _limit, search: _search)) {
      case Ok(:final value):
        _exercises = value;
        _hasMore = value.length == _limit; // полная страница -> видимо, есть ещё
      case Err(:final msg):
        _error = msg;
    }
    _loading = false;
    notifyListeners();
  }

  // следующий ломоть. Вызывается из build-а хвоста списка, поэтому
  // _loadingMore ставится БЕЗ notifyListeners() (иначе setState во время build).
  Future<void> loadMore() async {
    if (_loadingMore || _loading || !_hasMore) return;
    _loadingMore = true;
    switch (await _repository.fetchAll(page: _page + 1, limit: _limit, search: _search)) {
      case Ok(:final value):
        _page += 1;
        _exercises = [..._exercises, ...value]; // страница приклеивается
        _hasMore = value.length == _limit;
      case Err():
        _hasMore = false;
    }
    _loadingMore = false;
    notifyListeners();
  }
}
