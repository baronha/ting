package com.ting

import android.content.Context
import android.graphics.Color
import android.graphics.drawable.Animatable
import android.graphics.drawable.AnimatedVectorDrawable
import android.view.Gravity
import android.view.LayoutInflater
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.UiThreadUtil.runOnUiThread
import com.hjq.window.EasyWindow


class TingModule internal constructor(context: ReactApplicationContext) :
  TingSpec(context) {

  private var context: Context = context


  @ReactMethod
  override fun toast(options: ReadableMap) {

    val activity = currentActivity
    val inflater = LayoutInflater.from(context)

    val container = inflater.inflate(
      R.layout.toast, null
    ) as LinearLayout

//    val containerView: LinearLayout = container.findViewById(R.id.toast)
    val messageView: TextView = container.findViewById(R.id.message)
    val titleView: TextView = container.findViewById(R.id.title)
//    val icon: ImageView = container.findViewById(R.id.icon)

    val title = options?.getString("title")
    val message = options?.getString("message")
    val preset = options?.getString("preset")

    titleView.text = title
    messageView.text = message
//    icon.setImageResource()


    runOnUiThread {
      EasyWindow<EasyWindow<*>>(activity)
//        .setDuration(3000)
        .setContentView(container)
        .setAnimStyle(R.style.IOSAnimStyle)
        .setImageDrawable(R.id.icon, R.drawable.toast_success_ic)
        .setOutsideTouchable(true)
        .setYOffset(0)
        .setBackgroundDimAmount(0.5f)
        .setOnClickListener(
          R.id.toast,
          EasyWindow.OnClickListener<LinearLayout?> { window, view -> window.cancel() })
        .show()
    }

//    Handler(Looper.getMainLooper()).post(Runnable {
//
//    })


  }

  @ReactMethod
  override fun alert(options: ReadableMap) {
//
  }

  override fun getName(): String {
    return NAME
  }

  companion object {
    const val NAME = "Ting"
  }
}
