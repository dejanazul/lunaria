-- Function untuk melakukan pencarian similaritas pada vector_documents
CREATE OR REPLACE FUNCTION match_documents(
  query_text TEXT DEFAULT NULL,
  query_embedding vector DEFAULT NULL,
  match_threshold FLOAT DEFAULT 0.7,
  match_count INT DEFAULT 5
)
RETURNS TABLE (
  id BIGINT,
  title TEXT,
  content TEXT,
  similarity FLOAT
)
LANGUAGE plpgsql
AS $$
DECLARE
  embedding_vector vector;
BEGIN
  -- Jika embedding tidak disediakan tapi query text disediakan,
  -- gunakan OpenAI atau embedding provider yang dikonfigurasi di Supabase
  IF query_embedding IS NULL AND query_text IS NOT NULL THEN
    -- Kode ini mengasumsikan Anda menggunakan pgvector dengan OpenAI di Supabase
    -- Jika menggunakan provider lain, sesuaikan function call-nya
    embedding_vector := openai.embed(query_text);
  ELSE
    embedding_vector := query_embedding;
  END IF;

  -- Pastikan vector tidak null
  IF embedding_vector IS NULL THEN
    RAISE EXCEPTION 'Embedding vector tidak boleh null';
  END IF;

  RETURN QUERY
  SELECT
    vd.id,
    vd.title,
    vd.content,
    1 - (vd.embedding <=> embedding_vector) AS similarity
  FROM
    vector_documents vd
  WHERE 
    1 - (vd.embedding <=> embedding_vector) > match_threshold
  ORDER BY
    vd.embedding <=> embedding_vector
  LIMIT match_count;
END;
$$;
