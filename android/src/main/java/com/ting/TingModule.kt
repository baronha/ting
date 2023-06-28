package com.ting

import android.content.Context
import android.widget.TextView
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap
import com.hjq.window.EasyWindow

class TingModule internal constructor(context: ReactApplicationContext) :
  TingSpec(context) {

  private var context: Context = context


  @ReactMethod
  override fun toast(options: ReadableMap) {
    val activity = currentActivity


    EasyWindow<EasyWindow<*>>(activity).apply {
      setContentView(R.layout.toast)
      // 设置成可拖拽的
      //setDraggable()
      // 设置显示时长
      setDuration(1000)
      // 设置动画样式
      //setAnimStyle(android.R.style.Animation_Translucent)
      // 设置外层是否能被触摸
      //setOutsideTouchable(false)
      // 设置窗口背景阴影强度
      //setBackgroundDimAmount(0.5f)
//      setImageDrawable(android.R.id.icon, R.mipmap.ic_dialog_tip_finish)
      setText(android.R.id.message, "点我消失")
      setOnClickListener(android.R.id.message, EasyWindow.OnClickListener<TextView?> { toast: EasyWindow<*>, _: TextView? ->
        // 点击这个 View 后消失
        toast.cancel()
        // 跳转到某个Activity
        // toast.startActivity(intent);
      })
    }.show()
  }

  @ReactMethod
  override fun alert(options: ReadableMap) {
    TODO("Not yet implemented")
  }

  override fun getName(): String {
    return NAME
  }

  companion object {
    const val NAME = "Ting"
  }
}
