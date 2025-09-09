import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> similaritySearch({
    String? query,
    List<double>? embeddings,
    double matchThreshold = 0.7,
    int matchCount = 1,
  }) async {
    debugPrint('============= DEBUG: SIMILARITY SEARCH =============');
    debugPrint('🔍 Melakukan pencarian similaritas dengan embedding');

    // Menggunakan embeddings yang diberikan
    List<double> queryEmbedding = embeddings ?? [];

    // Validasi: harus ada queryEmbedding
    if (queryEmbedding.isEmpty) {
      debugPrint('❌ Error: Embeddings tidak boleh kosong');
      return [];
    }

    debugPrint('🔍 Embedding dimensi: ${queryEmbedding.length}');
    debugPrint('🔍 Threshold: $matchThreshold, Max Results: $matchCount');

    try {
      debugPrint('📤 Mengirim parameter ke Supabase RPC:');
      debugPrint('📤 Function: search_documents');
      debugPrint('📤 query_embedding: ${queryEmbedding.length} dimensi');
      debugPrint('📤 match_count: $matchCount');

      // Langsung pass array ke Supabase, akan otomatis dikonversi ke vector
      final response = await _client.rpc(
        'search_documents',
        params: {
          'query_embedding': queryEmbedding, // Supabase otomatis convert array → vector
          'match_count': matchCount, // opsional, default 5
        },
      );

      debugPrint('✅ RESPONSE: $response');

      // HAPUS PENGECEKAN response.error - Tidak diperlukan!
      // Langsung proses response sebagai List
      final results = List<Map<String, dynamic>>.from(response);
      
      debugPrint('✅ Hasil pencarian: ${results.length} dokumen ditemukan');

      if (results.isNotEmpty) {
        debugPrint(
          '✅ Top result similarity: ${results[0]['similarity']?.toStringAsFixed(4)}',
        );
        debugPrint(
          '✅ Content preview: "${results[0]['content']?.toString().substring(0, 50)}..."',
        );
      }

      debugPrint('============= END SIMILARITY SEARCH =============');
      return results;
    } catch (e) {
      debugPrint('❌ Error dalam similaritySearch: $e');
      debugPrint('============= END SIMILARITY SEARCH (ERROR) =============');
      return [];
    }
  }
}