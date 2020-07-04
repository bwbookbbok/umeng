package com.bluewhitepants.umeng

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.NonNull
import anet.channel.util.Utils
import com.umeng.analytics.MobclickAgent
import com.umeng.message.UTrack.ICallBack
import com.umeng.message.tag.TagManager.TCallBack
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar


/** UmengPlugin */
public class UmengPlugin : FlutterPlugin, MethodCallHandler {

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        Log.i("UmengPlugin", "onAttachedToEngine")

        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "flutter_umeng_20200703_channel/event")
        eventChannel.setStreamHandler(
                object : EventChannel.StreamHandler {
                    override fun onListen(args111: Any?, events: EventSink) {
                        Log.i("eventChannel", "adding listener")
                        eventSink = events
                    }
                    override fun onCancel(args: Any?) {
                        Log.i("eventChannel", "cancelling listener")
                        eventSink = null
                    }
                }
        )

        context = flutterPluginBinding.applicationContext
        methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_umeng_20200703_channel")
        methodChannel!!.setMethodCallHandler(this)

    }

    companion object {
        var methodChannel: MethodChannel? = null
        lateinit var  eventChannel: EventChannel
        var eventSink: EventSink? = null
        private var context: Context? = null

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            Log.e("UmengPlugin", "onAttachedToEngine")

            context = registrar.context()
            methodChannel = MethodChannel(registrar.view(), "flutter_umeng_20200703_channel")
            methodChannel!!.setMethodCallHandler(UmengPlugin())

            eventChannel = EventChannel(registrar.view(), "flutter_umeng_20200703_channel/event")
            eventChannel.setStreamHandler(
                    object : EventChannel.StreamHandler {
                        override fun onListen(args: Any, events: EventSink) {
                            Log.i("eventChannel", "adding listener")
                            eventSink = events
                        }

                        override fun onCancel(args: Any) {
                            Log.i("eventChannel", "cancelling listener")
                            eventSink = null
                        }
                    }
            )
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else if (call.method == "addTags") {
            addTags(call, result);
        } else if (call.method == ("deleteTags")) {
            deleteTags(call, result);
        } else if (call.method == ("addAlias")) {
            addAlias(call, result);
        } else if (call.method == ("setAlias")) {
            setAlias(call, result);
        } else if (call.method == ("deleteAlias")) {
            deleteAlias(call, result);
        } else if (call.method == ("pageStart")) {
            pageStart(call, result);
        } else if (call.method == ("pageEnd")) {
            pageEnd(call, result);
        } else if (call.method == ("event")) {
            event(call, result);
        } else {
            result.notImplemented();
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        Log.i("UmengPlugin", "onDetachedFromEngine")
        methodChannel?.setMethodCallHandler(null);
        eventChannel?.setStreamHandler(null);
    }

    private fun event(call: MethodCall, result: Result) {
        val eventId = call.argument<String>("eventId")
        val label = call.argument<String>("label")
        MobclickAgent.onEvent(Utils.context, eventId, label)
    }

    private fun pageStart(call: MethodCall, result: Result) {
        val pageName = call.argument<String>("pageName")
        MobclickAgent.onPageStart(pageName)
    }

    private fun pageEnd(call: MethodCall, result: Result) {
        val pageName = call.argument<String>("pageName")
        MobclickAgent.onPageEnd(pageName)
    }

    private fun addTags(call: MethodCall, result: Result) {
        val tags = call.argument<String>("tags")
        UmengHelper.UmengPushAgent?.tagManager?.addTags(TCallBack { isSuccess, _ -> Log.i("umeng_push_tags", "addTags：--> $isSuccess") }, tags)
    }

    private fun deleteTags(call: MethodCall, result: Result) {
        val tags = call.argument<String>("tags")
        UmengHelper.UmengPushAgent?.tagManager?.deleteTags(TCallBack { isSuccess, _ -> Log.i("umeng_push_tags", "deleteTags：--> $isSuccess") }, tags)
    }

    private fun addAlias(call: MethodCall, result: Result) {
        val alias = call.argument<String>("alias")
        val type = call.argument<String>("type")
        UmengHelper.UmengPushAgent?.addAlias(alias, type, ICallBack { isSuccess, message -> Log.i("umeng_push_alias", "addAlias：--> $isSuccess; 消息：--> $message") })
    }

    private fun setAlias(call: MethodCall, result: Result) {
        Log.i("umeng_push_alias", "setAlias click")
        if (UmengHelper.UmengPushAgent == null) {
            result.error("-1", "setAlias UmengPushAgent is null", "")
            return;
        } else {
            Log.i("umeng_push_alias", "UmengPushAgent not null")
        }
        val alias = call.argument<String>("alias")
        val type = call.argument<String>("type")


        UmengHelper.UmengPushAgent?.setAlias(alias, type, ICallBack { isSuccess, message ->
            Log.i("umeng_push_alias", "addAlias：--> $isSuccess; 消息：--> $message")
            Handler(Looper.getMainLooper()).post(Runnable { eventSink?.success(mapOf("is_suc" to isSuccess, "msg" to  message)) })
        })
        result.success("call Result")
    }


    private fun deleteAlias(call: MethodCall, result: Result) {
        val alias = call.argument<String>("alias")
        val type = call.argument<String>("type")
        UmengHelper.UmengPushAgent?.deleteAlias(alias, type, ICallBack { isSuccess, message -> Log.i("umeng_push_alias", "deleteAlias：--> $isSuccess; 消息：--> $message") })

    }
}
