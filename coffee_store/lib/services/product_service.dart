import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/coffee_data.dart';
import '../models/coffee.dart';

/// Keeps the product list in sync with the Supabase `products` table.
/// Any INSERT / UPDATE / DELETE in the dashboard shows up in the app instantly.
class ProductService {
  static final SupabaseClient _db = Supabase.instance.client;

  /// Starts with the local list (works offline / before first load),
  /// then gets replaced by the live data from Supabase.
  static final ValueNotifier<List<Coffee>> products =
      ValueNotifier<List<Coffee>>(List<Coffee>.of(homeCoffees));

  static StreamSubscription<List<Map<String, dynamic>>>? _sub;

  /// Call once, right after Supabase.initialize().
  static void start() {
    _sub?.cancel();
    _sub = _db
        .from('products')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: true)
        .listen(_onRows, onError: (e) => debugPrint('Products stream error: $e'));
  }

  static void stop() => _sub?.cancel();

  static void _onRows(List<Map<String, dynamic>> rows) {
    // Remember favorites / saved recipes so they survive a refresh.
    final previous = {for (final c in products.value) c.name: c};

    products.value = rows
        .where((r) => r['is_active'] != false)
        .map((r) {
          final c = Coffee.fromMap(r);
          final old = previous[c.name];
          if (old != null) {
            c.favorite = old.favorite;
            c.savedSize = old.savedSize;
            c.savedSugar = old.savedSugar;
            c.savedTemp = old.savedTemp;
          }
          return c;
        })
        .toList();
  }
}