package com.template.mobile_template

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Intent
import androidx.core.content.FileProvider
import java.io.File

class MainActivity : FlutterActivity() {
    private var channel: MethodChannel? = null
    private var pendingId: Int? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        pendingId = intent.getIntExtra("saving_impulse", -1).takeIf { it > 0 }
        intent.removeExtra("saving_impulse")
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "not_spent/native")
        channel!!.setMethodCallHandler { call, result ->
            when (call.method) {
                "consumeTap" -> { result.success(pendingId); pendingId = null }
                "syncWidget" -> {
                    getSharedPreferences("savings_widget", MODE_PRIVATE).edit()
                        .putString("items", call.arguments as? String ?: "[]").apply()
                    SavingsWidgetProvider.refresh(this)
                    result.success(null)
                }
                "shareReceipt" -> {
                    try {
                        val bytes = call.arguments as ByteArray
                        val directory = File(cacheDir, "receipts").apply { mkdirs() }
                        val file = File(directory, "not-spent.png")
                        file.writeBytes(bytes)
                        val uri = FileProvider.getUriForFile(this, "$packageName.receipts", file)
                        val share = Intent(Intent.ACTION_SEND).apply {
                            type = "image/png"
                            putExtra(Intent.EXTRA_STREAM, uri)
                            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                            clipData = android.content.ClipData.newRawUri("receipt", uri)
                        }
                        startActivity(Intent.createChooser(share, getString(R.string.receipt_share)))
                        result.success(null)
                    } catch (error: Exception) { result.error("receipt_export", error.message, null) }
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        val id = intent.getIntExtra("saving_impulse", -1).takeIf { it > 0 }
        intent.removeExtra("saving_impulse")
        if (id != null) {
            pendingId = id
            channel?.invokeMethod("quickSaving", id, object : MethodChannel.Result {
                override fun success(result: Any?) { if (pendingId == id) pendingId = null }
                override fun error(code: String, message: String?, details: Any?) {}
                override fun notImplemented() {}
            })
        }
    }
}
