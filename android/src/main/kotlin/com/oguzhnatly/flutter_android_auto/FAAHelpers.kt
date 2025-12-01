package com.oguzhnatly.flutter_android_auto

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.util.Base64
import androidx.car.app.model.CarIcon
import androidx.core.graphics.drawable.IconCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.FlutterInjector
import java.io.File
import java.net.HttpURLConnection
import java.net.URL
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

object FAAHelpers {
    var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding? = null

    fun makeFCPChannelId(event: String): String {
        return "com.oguzhnatly.flutter_android_auto" + event
    }
}

/**
 * Loads an image from various sources and returns a CarIcon.
 * Supports:
 * - Flutter assets (e.g., "assets/image.png")
 * - HTTP/HTTPS URLs (e.g., "https://example.com/image.png")
 * - Local file paths (e.g., "file:///path/to/image.png")
 * - Base64 encoded images (raw base64 or data URL format)
 */
suspend fun loadCarImageAsync(imagePath: String): CarIcon? {
    if (imagePath.isEmpty()) return null

    return withContext(Dispatchers.IO) {
        try {
            val bitmap = when {
                // Base64 encoded image (data URL format)
                imagePath.startsWith("data:image") -> {
                    loadFromBase64(imagePath)
                }
                // HTTP/HTTPS URL
                imagePath.startsWith("http://") || imagePath.startsWith("https://") -> {
                    loadFromUrl(imagePath)
                }
                // Local file path
                imagePath.startsWith("file://") -> {
                    loadFromFile(imagePath)
                }
                // Raw base64 (long string without other prefixes)
                imagePath.length > 200 && !imagePath.contains("/") && !imagePath.contains(".") -> {
                    loadFromBase64(imagePath)
                }
                // Flutter asset (default)
                else -> {
                    loadFromFlutterAsset(imagePath)
                }
            }

            bitmap?.let {
                val iconCompat = IconCompat.createWithBitmap(it)
                CarIcon.Builder(iconCompat).build()
            }
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }
}

private fun loadFromBase64(dataString: String): Bitmap? {
    return try {
        val base64String = if (dataString.startsWith("data:image")) {
            // Extract base64 data from data URL (e.g., "data:image/png;base64,...")
            dataString.substringAfter(",")
        } else {
            dataString
        }
        val decodedBytes = Base64.decode(base64String, Base64.DEFAULT)
        BitmapFactory.decodeByteArray(decodedBytes, 0, decodedBytes.size)
    } catch (e: Exception) {
        e.printStackTrace()
        null
    }
}

private fun loadFromUrl(imageUrl: String): Bitmap? {
    return try {
        val url = URL(imageUrl)
        val connection = url.openConnection() as HttpURLConnection
        connection.doInput = true
        connection.connect()
        val inputStream = connection.inputStream
        BitmapFactory.decodeStream(inputStream)
    } catch (e: Exception) {
        e.printStackTrace()
        null
    }
}

private fun loadFromFile(filePath: String): Bitmap? {
    return try {
        val path = filePath.removePrefix("file://")
        BitmapFactory.decodeFile(path)
    } catch (e: Exception) {
        e.printStackTrace()
        null
    }
}

private fun loadFromFlutterAsset(assetPath: String): Bitmap? {
    return try {
        val flutterLoader = FlutterInjector.instance().flutterLoader()
        val assetKey = flutterLoader.getLookupKeyForAsset(assetPath)

        val context = FAAHelpers.flutterPluginBinding?.applicationContext
            ?: return null

        val assetManager = context.assets
        val inputStream = assetManager.open(assetKey)
        BitmapFactory.decodeStream(inputStream)
    } catch (e: Exception) {
        e.printStackTrace()
        null
    }
}

