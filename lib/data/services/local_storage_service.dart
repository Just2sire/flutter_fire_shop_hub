import "dart:convert";

import "../../domain/storage_key.dart";
import "../datasources/local/i_storage_datasource.dart";

class StorageService {
  const StorageService({
    required this._secure,
    required this._regular,
  });

  final IStorageDatasource _secure;
  final IStorageDatasource _regular;

  // Routing automatique selon la clé
  IStorageDatasource _pick(StorageKey key) =>
      key.secure ? _secure : _regular;

  // ─── Core ───────────────────────────────────────

  Future<void> write(StorageKey key, String value) =>
      _pick(key).write(key.name, value);

  Future<String?> read(StorageKey key) =>
      _pick(key).read(key.name);

  Future<void> delete(StorageKey key) =>
      _pick(key).delete(key.name);

  Future<void> clearAll() async {
    await _secure.clear();
    await _regular.clear();
  }

  // ─── Typed helpers ──────────────────────────────

  Future<void> writeBool(StorageKey key, bool value) =>
      write(key, value.toString());

  Future<bool?> readBool(StorageKey key) async {
    final v = await read(key);
    if (v == null) return null;
    return v == "true";
  }

  Future<void> writeInt(StorageKey key, int value) =>
      write(key, value.toString());

  Future<int?> readInt(StorageKey key) async {
    final v = await read(key);
    return v != null ? int.tryParse(v) : null;
  }

  Future<void> writeDouble(StorageKey key, double value) =>
      write(key, value.toString());

  Future<double?> readDouble(StorageKey key) async {
    final v = await read(key);
    return v != null ? double.tryParse(v) : null;
  }

  Future<void> writeJson(StorageKey key, Map<String, dynamic> value) =>
      write(key, jsonEncode(value));

  Future<Map<String, dynamic>?> readJson(StorageKey key) async {
    final v = await read(key);
    if (v == null) return null;
    try {
      return jsonDecode(v) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<void> writeList(StorageKey key, List<String> value) =>
      write(key, jsonEncode(value));

  Future<List<String>?> readList(StorageKey key) async {
    final v = await read(key);
    if (v == null) return null;
    try {
      return (jsonDecode(v) as List).cast<String>();
    } catch (_) {
      return null;
    }
  }

  // ─── Utilitaires ────────────────────────────────

  Future<bool> has(StorageKey key) async =>
      (await read(key)) != null;
}
