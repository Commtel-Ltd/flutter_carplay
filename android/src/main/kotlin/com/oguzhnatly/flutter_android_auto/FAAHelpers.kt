package com.oguzhnatly.flutter_android_auto

import android.content.Context
import android.graphics.BitmapFactory
import android.util.Base64
import androidx.car.app.model.CarIcon
import androidx.core.graphics.drawable.IconCompat
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.plugins.FlutterPlugin
import java.io.File
import java.net.HttpURLConnection
import java.net.URL
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

object FAAHelpers {
    /// Kept so asset/file icons can be resolved via the application context
    /// before a car session (and its CarContext) exists.
    var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding? = null

    fun makeFCPChannelId(event: String): String {
        return "com.oguzhnatly.flutter_android_auto" + event
    }
}

fun makeCarIconFromBytes(bytes: ByteArray?): CarIcon? {
    return makeCarIconFromBytes(bytes, null)
}

fun makeCarIconFromBytes(bytes: ByteArray?, imageTint: FAAImageTint?): CarIcon? {
    if (bytes == null || bytes.isEmpty()) return null
    return try {
        val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size) ?: return null
        bitmap.toCarIcon(imageTint)
    } catch (e: Exception) {
        e.printStackTrace()
        null
    }
}

suspend fun loadCarImageFromAsset(
    context: Context,
    assetPath: String,
    imageTint: FAAImageTint? = null,
): CarIcon? {
    return withContext(Dispatchers.IO) {
        try {
            val key = FlutterInjector.instance().flutterLoader()
                .getLookupKeyForAsset(assetPath)
            context.assets.open(key).use { inputStream ->
                val bitmap = BitmapFactory.decodeStream(inputStream) ?: return@use null
                bitmap.toCarIcon(imageTint)
            }
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }
}

suspend fun loadCarImageFromFile(
    path: String,
    imageTint: FAAImageTint? = null,
): CarIcon? {
    return withContext(Dispatchers.IO) {
        try {
            val filePath = path.removePrefix("file://")
            val file = File(filePath)
            if (!file.exists()) return@withContext null
            val bitmap = BitmapFactory.decodeFile(filePath) ?: return@withContext null
            bitmap.toCarIcon(imageTint)
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }
}

suspend fun resolveCarIcon(
    context: Context,
    bytes: ByteArray?,
    imageUrl: String?,
    imageTint: FAAImageTint? = null,
): CarIcon? {
    makeCarIconFromBytes(bytes, imageTint)?.let { return it }

    val source = imageUrl?.trim()
    if (source.isNullOrEmpty()) return null

    return when {
        source.startsWith("http") -> loadCarImageAsync(source, imageTint)
        source.startsWith("file://") -> loadCarImageFromFile(source, imageTint)
        isBase64ImageSource(source) -> loadCarImageFromBase64(source, imageTint)
        else -> loadCarImageFromAsset(context, source, imageTint)
    }
}

/**
 * Detects base64 image sources: either a "data:image/...;base64,..." data URL
 * or a raw base64 blob (far longer than any asset path).
 */
private fun isBase64ImageSource(source: String): Boolean {
    if (source.startsWith("data:image")) return true
    if (source.length <= 100) return false
    return try {
        Base64.decode(source, Base64.DEFAULT)
        true
    } catch (e: IllegalArgumentException) {
        false
    }
}

suspend fun loadCarImageFromBase64(
    dataString: String,
    imageTint: FAAImageTint? = null,
): CarIcon? {
    return withContext(Dispatchers.IO) {
        try {
            val base64String = if (dataString.startsWith("data:image")) {
                dataString.substringAfter(",")
            } else {
                dataString
            }
            val decodedBytes = Base64.decode(base64String, Base64.DEFAULT)
            val bitmap =
                BitmapFactory.decodeByteArray(decodedBytes, 0, decodedBytes.size)
                    ?: return@withContext null
            bitmap.toCarIcon(imageTint)
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }
}

suspend fun loadCarImageAsync(
    imageUrl: String,
    imageTint: FAAImageTint? = null,
): CarIcon? {
    return withContext(Dispatchers.IO) {
        try {
            val url = URL(imageUrl)
            val connection = url.openConnection() as HttpURLConnection
            connection.doInput = true
            connection.connect()
            val inputStream = connection.inputStream
            val bitmap = BitmapFactory.decodeStream(inputStream) ?: return@withContext null
            bitmap.toCarIcon(imageTint)
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }
}

private fun android.graphics.Bitmap.toCarIcon(imageTint: FAAImageTint? = null): CarIcon {
    val iconCompat = IconCompat.createWithBitmap(this)
    val builder = CarIcon.Builder(iconCompat)
    if (imageTint != null) {
        builder.setTint(imageTint.toCarColor())
    }
    return builder.build()
}
