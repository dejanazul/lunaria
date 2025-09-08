# Integrasi Text Embedding Service (LazarusNLP)

## Gambaran Umum

Sistem ini menggunakan model embedding LazarusNLP (all-indo-e5-small-v4) untuk mengubah pertanyaan pengguna menjadi vector embedding, lalu melakukan pencarian similaritas pada database Supabase menggunakan pgvector. Hasil pencarian ini digunakan untuk memberikan jawaban yang relevan dan akurat.

## Komponen Utama

### 1. TextEmbedService
- Menggunakan model LazarusNLP/all-indo-e5-small-v4 melalui Hugging Face API
- Model ini khusus dioptimalkan untuk bahasa Indonesia
- API Key Hugging Face tersimpan langsung di service

### 2. SupabaseService
- Melakukan pencarian similaritas pada tabel vector_documents
- Mendukung pencarian dengan vector embedding atau teks biasa
- Menggunakan stored procedure 'match_documents' di Supabase

### 3. QuestionAnsweringService
- Menggabungkan TextEmbedService dan GeminiService
- Menggunakan RAG (Retrieval Augmented Generation) untuk menjawab pertanyaan
- Menampilkan indikator apakah jawaban berasal dari database atau LLM

## Alur Kerja

1. Pengguna mengirimkan pertanyaan
2. TextEmbedService mengubah pertanyaan menjadi vector embedding
3. SupabaseService mencari dokumen dengan similaritas tertinggi
4. Jika ditemukan dokumen relevan (similaritas > threshold):
   - QuestionAnsweringService menyusun prompt berisi konteks dari dokumen
   - GeminiService memberikan jawaban berdasarkan prompt dengan konteks
5. Jika tidak ada dokumen relevan:
   - GeminiService memberikan jawaban berdasarkan pengetahuan umumnya

## Model Embedding: LazarusNLP/all-indo-e5-small-v4

- Model khusus untuk bahasa Indonesia
- Berbasis E5 (Embeddings from bidirectional Encoder)
- Dimensi embedding: 384
- Cocok untuk aplikasi similarity search dan retrieval
- Performance tinggi dengan ukuran model yang kecil

## Setup untuk Pengembang

1. Pastikan API Key Hugging Face di TextEmbedService valid
2. Buat stored procedure 'match_documents' di Supabase
3. Pastikan tabel vector_documents sudah dibuat dengan kolom embedding
4. Untuk testing, tambahkan data ke vector_documents dengan embeddings

## Optimasi dan Pengembangan Lanjutan

1. **Caching Embeddings**: Simpan embedding yang sering digunakan untuk mengurangi API calls
2. **Fine-tuning Model**: Model bisa di-fine-tuning untuk domain kesehatan dan fitness perempuan
3. **Batching Queries**: Implementasikan batching untuk query yang banyak
4. **Monitoring**: Tambahkan logging untuk melihat performa dan akurasi dari sistem
