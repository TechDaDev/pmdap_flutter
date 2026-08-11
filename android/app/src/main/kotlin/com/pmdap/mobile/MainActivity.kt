package com.pmdap.mobile

import android.app.Activity
import android.content.Intent
import android.net.Uri
import com.google.mlkit.vision.documentscanner.GmsDocumentScannerOptions
import com.google.mlkit.vision.documentscanner.GmsDocumentScannerOptions.RESULT_FORMAT_JPEG
import com.google.mlkit.vision.documentscanner.GmsDocumentScannerOptions.RESULT_FORMAT_PDF
import com.google.mlkit.vision.documentscanner.GmsDocumentScannerOptions.SCANNER_MODE_FULL
import com.google.mlkit.vision.documentscanner.GmsDocumentScanning
import com.google.mlkit.vision.documentscanner.GmsDocumentScanningResult
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

/// Thin bridge to Google's ML Kit document scanner (GmsDocumentScanning).
///
/// Uses the Google Play services scanner UI — PMDAP itself never requests
/// CAMERA permission and never processes pages; it only copies the returned
/// page images / PDF into the app-private cache for authenticated upload.
class MainActivity : FlutterActivity() {
    private val channelName = "pmdap/document_scanner"
    private val requestScan = 1001
    private var pendingResult: MethodChannel.Result? = null

    private val scannerOptions = GmsDocumentScannerOptions.Builder()
        .setGalleryImportAllowed(false)
        .setPageLimit(20)
        .setResultFormats(RESULT_FORMAT_JPEG, RESULT_FORMAT_PDF)
        .setScannerMode(SCANNER_MODE_FULL)
        .build()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "scan" -> {
                        if (pendingResult != null) {
                            result.error("busy", "Scanner already running", null)
                            return@setMethodCallHandler
                        }
                        pendingResult = result
                        val scanner = GmsDocumentScanning.getClient(scannerOptions)
                        scanner.getStartScanIntent(this)
                            .addOnSuccessListener { sender: android.content.IntentSender ->
                                startIntentSenderForResult(
                                    sender,
                                    requestScan,
                                    null,
                                    0,
                                    0,
                                    0
                                )
                            }
                            .addOnFailureListener { e ->
                                pendingResult = null
                                result.error(
                                    "unavailable",
                                    e.message ?: "Document scanner unavailable",
                                    null
                                )
                            }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    @Deprecated("Deprecated in Android 11 but still the canonical Gms flow here")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == requestScan) {
            handleScannerResult(resultCode, data)
        }
    }

    private fun handleScannerResult(resultCode: Int, data: Intent?) {
        val result = pendingResult
        pendingResult = null
        if (result == null) return
        if (resultCode != Activity.RESULT_OK || data == null) {
            result.success(mapOf("cancelled" to true))
            return
        }
        val scanResult = GmsDocumentScanningResult.fromActivityResultIntent(data)
        if (scanResult == null) {
            result.success(mapOf("cancelled" to true))
            return
        }
        val pageUris = scanResult.pages?.map { it.imageUri } ?: emptyList()
        val pdfUri = scanResult.pdf?.uri
        val stamp = System.currentTimeMillis()
        val pagePaths = pageUris.mapIndexed { i, uri ->
            copyUriToCache(uri, File(cacheDir, "scan_page_${stamp}_$i.jpg")).absolutePath
        }
        val pdfPath = pdfUri?.let {
            copyUriToCache(it, File(cacheDir, "scan_$stamp.pdf")).absolutePath
        }
        result.success(
            mapOf(
                "pages" to pagePaths,
                "pdf" to pdfPath,
                "pageCount" to (scanResult.pdf?.pageCount ?: pagePaths.size),
            )
        )
    }

    private fun copyUriToCache(uri: Uri, dest: File): File {
        contentResolver.openInputStream(uri)?.use { input ->
            FileOutputStream(dest).use { output -> input.copyTo(output) }
        }
        return dest
    }
}

