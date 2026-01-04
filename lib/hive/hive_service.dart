import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();
  
  factory HiveService() {
    return _instance;
  }
  
  HiveService._internal() {
    initHive();
  }

  static const String settingsBox = 'settings';
  static const String taskBox = 'tasks';
  static const String eventBox = 'events';
  static const String workBox = 'work';
  static const String testBox = 'testBox';

  static Future<void> initHive() async {
    await Hive.initFlutter().then(  
      (_) => debugPrint('✅ Hive initialized successfully\nAbrindo boxes...'),
    ).catchError(
      (error) => debugPrint('❌ Error initializing Hive: $error'),
    );

    await Hive.openBox(settingsBox);
    await Hive.openBox(taskBox);
    await Hive.openBox(eventBox);
    await Hive.openBox(workBox);
    await Hive.openBox(testBox);
  }

  static Box getBox(String nameBox) {
    return Hive.box(nameBox);
  }

  static Future<void> closeHive() async {
    await Hive.close().then(
      (_) => debugPrint('✅ Hive closed successfully'),
    ).catchError(
      (error) => debugPrint('❌ Error closing Hive: $error'),
    );
  }

  static Future<void> deleteBox(String nameBox) async {
    await Hive.deleteBoxFromDisk(nameBox).then(
      (_) => debugPrint('✅ Box $nameBox deleted successfully'),
    ).catchError(
      (error) => debugPrint('❌ Error deleting box $nameBox: $error'),
    );
  }

  static Future<void> clearBox(String nameBox) async {
    final box = Hive.box(nameBox);
    await box.clear().then(
      (_) => debugPrint('✅ Box $nameBox cleared successfully'),
    ).catchError(
      (error) => debugPrint('❌ Error clearing box $nameBox: $error'),
    );
  }

  static bool isBoxOpen(String nameBox) {
    return Hive.isBoxOpen(nameBox);
  }

  static Future<void> compactBox(String nameBox) async {
    final box = Hive.box(nameBox);
    await box.compact().then(
      (_) => debugPrint('✅ Box $nameBox compacted successfully'),
    ).catchError(
      (error) => debugPrint('❌ Error compacting box $nameBox: $error'),
    );
  }

  static Future<void> saveData(String nameBox, dynamic key, dynamic value, {bool isFullSave = false, Map<dynamic, dynamic>? fullData}) async {
    final box = Hive.box(nameBox);
    if (isFullSave && isBoxOpen(nameBox)) {
      await box.putAll(fullData ?? {}).then(
        (_) => debugPrint('✅ Multiple keys fully saved successfully in box $nameBox'),
      ).catchError(
        (error) => debugPrint('❌ Error fully saving data in box $nameBox: $error'),
      );
      return;
    }
    if (isBoxOpen(nameBox)) {
      await box.put(key, value).then(
        (_) => debugPrint('✅ Key $key saved successfully in box $nameBox'),
      ).catchError(
        (error) => debugPrint('❌ Error saving key $key in box $nameBox: $error'),
      );
    } else {
      debugPrint('❌ Box $nameBox is not open. Cannot save key $key.');
    }
  }

  static dynamic getData(String nameBox, dynamic key, {dynamic defaultValue}) {
    if (isBoxOpen(nameBox)) {
      final box = Hive.box(nameBox);
      return box.get(key, defaultValue: defaultValue);
    } else {
      debugPrint('❌ Box $nameBox is not open. Cannot get key $key.');
      return defaultValue;
    }
  }

  static Future<void> deleteData(String nameBox, dynamic key) async {
    if (isBoxOpen(nameBox)) {
      final box = Hive.box(nameBox);
      await box.delete(key).then(
        (_) => debugPrint('✅ Key $key deleted successfully from box $nameBox'),
      ).catchError(
        (error) => debugPrint('❌ Error deleting key $key from box $nameBox: $error'),
      );
    } else {
      debugPrint('❌ Box $nameBox is not open. Cannot delete key $key.');
    }
  }

  // Obtener todos los valores de una box como lista
  static List<dynamic> getAllValues(String nameBox) {
    if (isBoxOpen(nameBox)) {
      final box = Hive.box(nameBox);
      return box.values.toList();
    } else {
      debugPrint('❌ Box $nameBox is not open. Cannot get all values.');
      return [];
    }
  }

  // Obtener todos los datos como un Map
  static Map<dynamic, dynamic> getAllData(String nameBox) {
    if (isBoxOpen(nameBox)) {
      final box = Hive.box(nameBox);
      return Map.fromEntries(box.toMap().entries);
    } else {
      debugPrint('❌ Box $nameBox is not open. Cannot get all data.');
      return {};
    }
  }

  /// Buscar datos con filtros personalizados
  /// 
  /// [nameBox] - Nombre de la box
  /// [where] - Función de filtro que retorna true para elementos que coinciden
  /// [sortBy] - Función opcional para ordenar resultados
  /// [limit] - Límite opcional de resultados
  /// [skip] - Cantidad opcional de elementos a saltar (paginación)
  /// 
  /// Ejemplo:
  /// ```dart
  /// // Buscar tareas completadas
  /// var completed = HiveService.searchData(
  ///   HiveService.taskBox,
  ///   where: (data) => data['isCompleted'] == true,
  ///   sortBy: (a, b) => a['dueDate'].compareTo(b['dueDate']),
  ///   limit: 10
  /// );
  /// ```
  static List<dynamic> searchData(
    String nameBox, {
    bool Function(dynamic data)? where,
    int Function(dynamic a, dynamic b)? sortBy,
    int? limit,
    int? skip,
  }) {
    if (!isBoxOpen(nameBox)) {
      debugPrint('❌ Box $nameBox is not open. Cannot search data.');
      return [];
    }

    final box = Hive.box(nameBox);
    List<dynamic> results = box.values.toList();

    // Aplicar filtro
    if (where != null) {
      results = results.where(where).toList();
    }

    // Aplicar ordenamiento
    if (sortBy != null) {
      results.sort(sortBy);
    }

    // Aplicar paginación (skip)
    if (skip != null && skip > 0) {
      results = results.skip(skip).toList();
    }

    // Aplicar límite
    if (limit != null && limit > 0) {
      results = results.take(limit).toList();
    }

    return results;
  }

  /// Búsqueda con múltiples filtros y condiciones
  /// 
  /// [nameBox] - Nombre de la box
  /// [filters] - Map con pares clave-valor para filtrar
  /// [searchText] - Texto a buscar en campos especificados
  /// [searchFields] - Campos donde buscar el texto
  /// [dateRange] - Rango de fechas (inicio, fin)
  /// [dateField] - Campo de fecha a filtrar
  /// [sortBy] - Función de ordenamiento
  /// [ascending] - Si es verdadero, ordena ascendente
  /// [limit] - Límite de resultados
  /// 
  /// Ejemplo:
  /// ```dart
  /// var tasks = HiveService.advancedSearch(
  ///   HiveService.taskBox,
  ///   filters: {'isCompleted': false},
  ///   searchText: 'comprar',
  ///   searchFields: ['title', 'description'],
  ///   dateRange: (DateTime.now(), DateTime.now().add(Duration(days: 7))),
  ///   dateField: 'dueDate',
  ///   sortBy: (data) => data['dueDate'],
  ///   limit: 20
  /// );
  /// ```
  static List<dynamic> advancedSearch(
    String nameBox, {
    Map<String, dynamic>? filters,
    String? searchText,
    List<String>? searchFields,
    (DateTime start, DateTime end)? dateRange,
    String? dateField,
    dynamic Function(dynamic data)? sortBy,
    bool ascending = true,
    int? limit,
  }) {
    if (!isBoxOpen(nameBox)) {
      debugPrint('❌ Box $nameBox is not open. Cannot perform advanced search.');
      return [];
    }

    final box = Hive.box(nameBox);
    List<dynamic> results = box.values.toList();

    // Aplicar filtros exactos
    if (filters != null && filters.isNotEmpty) {
      results = results.where((item) {
        if (item is! Map) return false;
        return filters.entries.every((filter) => 
          item.containsKey(filter.key) && item[filter.key] == filter.value
        );
      }).toList();
    }

    // Aplicar búsqueda de texto
    if (searchText != null && searchText.isNotEmpty && searchFields != null) {
      final lowerSearchText = searchText.toLowerCase();
      results = results.where((item) {
        if (item is! Map) return false;
        return searchFields.any((field) {
          final value = item[field]?.toString().toLowerCase() ?? '';
          return value.contains(lowerSearchText);
        });
      }).toList();
    }

    // Aplicar filtro de rango de fechas
    if (dateRange != null && dateField != null) {
      results = results.where((item) {
        if (item is! Map || !item.containsKey(dateField)) return false;
        try {
          final date = item[dateField] is DateTime 
            ? item[dateField] as DateTime
            : DateTime.parse(item[dateField].toString());
          return date.isAfter(dateRange.$1.subtract(const Duration(seconds: 1))) &&
                 date.isBefore(dateRange.$2.add(const Duration(seconds: 1)));
        } catch (e) {
          return false;
        }
      }).toList();
    }

    // Aplicar ordenamiento
    if (sortBy != null) {
      results.sort((a, b) {
        final aValue = sortBy(a);
        final bValue = sortBy(b);
        final comparison = ascending 
          ? Comparable.compare(aValue as Comparable, bValue as Comparable)
          : Comparable.compare(bValue as Comparable, aValue as Comparable);
        return comparison;
      });
    }

    // Aplicar límite
    if (limit != null && limit > 0) {
      results = results.take(limit).toList();
    }

    return results;
  }

  /// Contar elementos que cumplen una condición
  static int count(String nameBox, {bool Function(dynamic data)? where}) {
    if (!isBoxOpen(nameBox)) {
      debugPrint('❌ Box $nameBox is not open. Cannot count.');
      return 0;
    }

    final box = Hive.box(nameBox);
    if (where == null) {
      return box.length;
    }
    return box.values.where(where).length;
  }

  /// Verificar si existe algún elemento que cumple una condición
  static bool exists(String nameBox, bool Function(dynamic data) where) {
    if (!isBoxOpen(nameBox)) {
      debugPrint('❌ Box $nameBox is not open. Cannot check existence.');
      return false;
    }

    final box = Hive.box(nameBox);
    return box.values.any(where);
  }
}