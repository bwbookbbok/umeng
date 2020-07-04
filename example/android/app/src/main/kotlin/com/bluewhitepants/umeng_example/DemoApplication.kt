package com.bluewhitepants.umeng_example

import com.bluewhitepants.umeng.UmengHelper
import io.flutter.app.FlutterApplication

class DemoApplication: FlutterApplication() {
    override fun onCreate() {
        super.onCreate();
        UmengHelper.androidInit(this, "5ee8cba0dbc2ec081340b58a", "default",
                true, "e04c4181f34de9eb3a60e815c233d41f", false)
    }
}