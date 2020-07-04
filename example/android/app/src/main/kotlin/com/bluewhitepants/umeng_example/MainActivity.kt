package com.bluewhitepants.umeng_example

import androidx.annotation.NonNull
import com.bluewhitepants.umeng.UmengHelper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }

    override fun onResume() {
        super.onResume()
        UmengHelper.androidOnPause(this)
    }

    override fun onPause() {
        super.onPause()
        UmengHelper.androidOnPause(this)
    }
}
