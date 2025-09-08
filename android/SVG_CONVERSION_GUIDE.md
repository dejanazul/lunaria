# Panduan Konversi SVG untuk Splash Screen

Untuk menggunakan gambar SVG sebagai splash screen di Android, perlu dilakukan konversi ke format yang sesuai. Ada beberapa cara untuk melakukannya:

## Opsi 1: Menggunakan Android Studio

1. Buka Android Studio
2. Klik kanan pada folder `res/drawable` di panel Project
3. Pilih "New" -> "Vector Asset"
4. Pilih "Local file (SVG, PSD)" dan arahkan ke file `assets/icons/splash_screen.svg`
5. Sesuaikan ukuran dan nama jika diperlukan
6. Klik "Next" dan kemudian "Finish"

## Opsi 2: Menggunakan Command Line

Anda dapat menggunakan tool `svg2android` atau `SVGOMG` (online) untuk mengkonversi SVG ke VectorDrawable.

```bash
# Contoh menggunakan Node.js tool
npm install -g svg2vectordrawable-cli
svg2vectordrawable -i assets/icons/splash_screen.svg -o android/app/src/main/res/drawable/splash_icon.xml
```

## Opsi 3: Menggunakan Online Converter

1. Kunjungi https://svg2vector.com/
2. Upload file `assets/icons/splash_screen.svg`
3. Download hasil konversi sebagai VectorDrawable
4. Simpan file hasil konversi ke `android/app/src/main/res/drawable/splash_icon.xml`

## Catatan Tambahan

- Jika SVG terlalu kompleks, Android mungkin tidak dapat merender dengan benar. Dalam kasus ini, lebih baik konversi ke PNG.
- Untuk perangkat lama (Android < 5.0), VectorDrawable tidak didukung, jadi perlu juga menyediakan alternatif berupa PNG.
- Gunakan Android Studio untuk melihat preview VectorDrawable dan memastikan hasilnya sesuai harapan.

## Langkah-langkah Setelah Konversi

1. Jika menggunakan PNG, letakkan file di folder `mipmap-*` sesuai resolusi
2. Update file `splash_logo.xml` untuk mereferensikan file hasil konversi
3. Build dan jalankan aplikasi untuk menguji splash screen
