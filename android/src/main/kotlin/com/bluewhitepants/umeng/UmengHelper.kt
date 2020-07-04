package com.bluewhitepants.umeng

import android.content.Context
import android.util.Log
import com.umeng.analytics.MobclickAgent
import com.umeng.commonsdk.UMConfigure
import com.umeng.message.IUmengRegisterCallback
import com.umeng.message.PushAgent
import com.umeng.message.UmengNotificationClickHandler
import com.umeng.message.entity.UMessage

object UmengHelper {
    var UmengPushAgent: PushAgent? = null
    fun androidInit(context: Context?, appKey: String?, channel: String?,
                    logEnable: Boolean, messageSecret: String, customMessage: Boolean) {
        UMConfigure.setLogEnabled(logEnable)
        UMConfigure.init(context, appKey, channel, UMConfigure.DEVICE_TYPE_PHONE, messageSecret)
        if (messageSecret.isNotEmpty()) {
            //获取消息推送代理示例
            val mPushAgent = PushAgent.getInstance(context)
            //注册推送服务，每次调用register方法都会回调该接口
            mPushAgent.register(object : IUmengRegisterCallback {
                override fun onSuccess(deviceToken: String) {
                    //注册成功会返回deviceToken deviceToken是推送消息的唯一标志
                    Log.i("umeng_push_register", "注册成功：deviceToken：-------->  $deviceToken")
                }

                override fun onFailure(s: String, s1: String) {
                    Log.e("umeng_push_register", "注册失败：-------->  s:$s,s1:$s1")
                }
            })
            if (customMessage) {
                val notificationClickHandler: UmengNotificationClickHandler = object : UmengNotificationClickHandler() {
                    override fun dealWithCustomAction(context: Context, msg: UMessage) {
                        Log.i("dealWithCustomAction", "：--------> " + msg.custom)
                        UmengPlugin.eventSink?.success(msg.custom)
                    }
                }
                mPushAgent.notificationClickHandler = notificationClickHandler
            }
            //后台进行日活统计及多维度推送的必调用方法，请务必调用
            mPushAgent.onAppStart()
            UmengPushAgent = mPushAgent
        }
    }

    fun androidOnResume(context: Context?) {
        MobclickAgent.onResume(context)
    }

    fun androidOnPause(context: Context?) {
        MobclickAgent.onPause(context)
    }
}