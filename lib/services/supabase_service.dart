import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;

  /// Melakukan pencarian similaritas pada dokumen di Supabase
  ///
  /// [query] - Query teks yang akan dicari
  /// [matchThreshold] - Nilai minimum similaritas yang dianggap relevan (0-1)
  /// [matchCount] - Jumlah maksimum dokumen yang dikembalikan
  /// [embeddings] - Vector embeddings yang sudah dihitung sebelumnya (opsional)
  ///
  /// Jika embeddings disediakan, menggunakan vector tersebut untuk pencarian
  /// Jika tidak, menggunakan query_text dan mengandalkan fungsi pgvector di Supabase
  static Future<List<Map<String, dynamic>>> similaritySearch({
    required String query,
    double matchThreshold = 0.7,
    int matchCount = 5,
    List<double>? embeddings,
  }) async {
    debugPrint('============= DEBUG: SIMILARITY SEARCH =============');
    debugPrint(
      '🔍 Melakukan pencarian similaritas untuk: "${query.substring(0, query.length > 50 ? 50 : query.length)}..."',
    );
    debugPrint('🔍 Threshold: $matchThreshold, Max Results: $matchCount');
    debugPrint(
      '🔍 Menggunakan embeddings? ${embeddings != null ? "Ya (${embeddings.length} dimensi)" : "Tidak"}',
    );

    try {
      final Map<String, dynamic> params = {
        'match_threshold': matchThreshold,
        'match_count': matchCount,
      };

      // Jika embeddings disediakan, konversi ke string untuk parameter query_embedding
      if (embeddings != null && embeddings.isNotEmpty) {
        final String vectorString = '[${embeddings.join(',')}]';
        params['query_embedding'] = vectorString;
      } else {
        // Jika tidak ada embeddings, gunakan query_text
        params['query_text'] = query;
      }

      final response = await _client.rpc(
        'vector_documents', // nama function RPC di Supabase
        params: params,
      );

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
