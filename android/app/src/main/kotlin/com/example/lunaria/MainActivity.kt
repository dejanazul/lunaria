package com.example.lunaria

import android.animation.ObjectAnimator
import android.os.Build
import android.os.Bundle
import android.view.View
import android.view.ViewTreeObserver
import android.view.animation.AnticipateInterpolator
import androidx.core.animation.doOnEnd
import androidx.core.view.WindowCompat
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // Pastikan UI berada di belakang system bars saat menggunakan splash screen
        WindowCompat.setDecorFitsSystemWindows(window, false)
        
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // Untuk Android 12+, gunakan SplashScreen API
            val splashScreen = installSplashScreen()
            
            // Konfigurasi animasi keluar
            splashScreen.setOnExitAnimationListener { splashScreenView ->
                // Buat animasi fade out
                val fadeOut = ObjectAnimator.ofFloat(
                    splashScreenView.view,
                    View.ALPHA,
                    1f,
                    0f
                )
                fadeOut.interpolator = AnticipateInterpolator()
                fadeOut.duration = 500L // 500ms
                
                // Hapus splash screen view setelah animasi selesai
                fadeOut.doOnEnd { splashScreenView.remove() }
                
                // Mulai animasi
                fadeOut.start()
            }
        }
        
        // Tunggu Flutter engine selesai diinisialisasi sebelum menghilangkan splash screen
        val content = findViewById<View>(android.R.id.content)
        content.viewTreeObserver.addOnPreDrawListener(
            object : ViewTreeObserver.OnPreDrawListener {
                override fun onPreDraw(): Boolean {
                    // Hapus callback ini agar tidak dipanggil lagi
                    content.viewTreeObserver.removeOnPreDrawListener(this)
                    // Kembalikan true untuk melanjutkan rendering
                    return true
                }
            }
        )
        
        super.onCreate(savedInstanceState)
    }
}
