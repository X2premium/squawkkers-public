package com.x2premium.squawkkers

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import android.os.Build
import android.os.Bundle
import android.widget.Toast
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val CHANNEL = "squawker/android_info"

    private val MY_PERMISSIONS_POST_NOTIFICATIONS = 1

    private val textActivityList = ArrayList<ResolveInfo>()
    private val callbackMap = HashMap<Int, MethodChannel.Result>()

    private var methodChannel: MethodChannel? = null

    override fun onPause() {
        super.onPause()
        try {
            Thread.sleep(200)
        } catch (e: InterruptedException) {
            e.printStackTrace()
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) return

        val intent = Intent().setAction(Intent.ACTION_PROCESS_TEXT).setType("text/plain")
        val lst = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            packageManager.queryIntentActivities(intent, PackageManager.ResolveInfoFlags.of(0))
        } else {
            @Suppress("DEPRECATION")
            packageManager.queryIntentActivities(intent, 0)
        }
        for (item in lst) {
            textActivityList.add(item)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        )
        methodChannel!!.setMethodCallHandler { call, result ->
            when (call.method) {
                "supportedTextActivityList" -> result.success(getTextActivityList())
                "processTextActivity" -> {
                    val callbackCode = result.hashCode()
                    callbackMap[callbackCode] = result
                    processTextActivity(
                        call.argument("value") ?: "",
                        call.argument("id") ?: -1,
                        call.argument("readonly") ?: true,
                        callbackCode
                    )
                }
                "requestPostNotificationsPermissions" -> {
                    requestPostNotificationsPermissions()
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun getTextActivityList() = arrayListOf<String>().apply {
        for (item in textActivityList) {
            add(item.loadLabel(packageManager).toString())
        }
    }

    private fun processTextActivity(value: String, id: Int, readonly: Boolean, callbackCode: Int) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) return

        val info = textActivityList.getOrNull(id) ?: return
        val intent = Intent().apply {
            setClassName(info.activityInfo.packageName, info.activityInfo.name)
            action = Intent.ACTION_PROCESS_TEXT
            putExtra(Intent.EXTRA_PROCESS_TEXT, value)
            putExtra(Intent.EXTRA_PROCESS_TEXT_READONLY, readonly)
            type = "text/plain"
        }
        startActivityForResult(intent, callbackCode)
    }

    @RequiresApi(Build.VERSION_CODES.M)
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        val result = if (resultCode == Activity.RESULT_OK) {
            data?.getStringExtra(Intent.EXTRA_PROCESS_TEXT)
        } else {
            null
        }
        returnResult(requestCode, result)
    }

    private fun returnResult(callbackCode: Int, result: String?) {
        callbackMap.remove(callbackCode)?.success(result)
    }

    private fun requestPostNotificationsPermissions() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED) {
                if (ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.POST_NOTIFICATIONS)) {
                    Toast.makeText(this, "Please grant permissions to post local notifications", Toast.LENGTH_LONG).show()
                    ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.POST_NOTIFICATIONS), MY_PERMISSIONS_POST_NOTIFICATIONS)
                } else {
                    ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.POST_NOTIFICATIONS), MY_PERMISSIONS_POST_NOTIFICATIONS)
                }
            }
            else {
                this@MainActivity.runOnUiThread {
                    methodChannel!!.invokeMethod("requestPostNotificationsPermissionsCallback", true)
                }
            }
        }
        else {
            this@MainActivity.runOnUiThread {
                methodChannel!!.invokeMethod("requestPostNotificationsPermissionsCallback", true)
            }
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        when (requestCode) {
            MY_PERMISSIONS_POST_NOTIFICATIONS -> {
                var granted = false
                if (grantResults.isNotEmpty()) {
                    granted = (grantResults[0] == PackageManager.PERMISSION_GRANTED)
                }
                this@MainActivity.runOnUiThread {
                    methodChannel!!.invokeMethod("requestPostNotificationsPermissionsCallback", granted)
                }
            }
        }
    }

}
