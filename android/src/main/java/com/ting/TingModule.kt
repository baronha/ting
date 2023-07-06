package com.ting

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Color
import android.graphics.drawable.Animatable
import android.graphics.drawable.AnimatedVectorDrawable
import android.net.Uri
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.UiThreadUtil.runOnUiThread
import com.hjq.window.EasyWindow
import java.io.IOException
import java.net.URI
import java.net.URL


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
    val iconView: ImageView = container.findViewById(R.id.icon)
    val layoutView: LinearLayout = container.findViewById(R.id.layoutView)

    val title = options?.getString("title")
    val message = options?.getString("message")
    val icon = options?.getMap("icon") as ReadableMap
    val iconURI = icon?.getString("uri")
    val preset = options?.getString("preset")

    //set title
    titleView.text = title

    // check message
    if (message == null) {
      messageView.visibility = TextView.GONE
    } else {
      messageView.text = message
    }

    println("icon: $icon")
    println("icon: $iconURI")


    if (iconURI == null) {
      when (preset) {
        "done" -> {
          iconView.setImageResource(R.drawable.background)
//            val animatedVectorDrawable = iconView.drawable as AnimatedVectorDrawable
//            animatedVectorDrawable.start()
        }

        "error" -> Preset.Error
        "none" -> {
          iconView.visibility = ImageView.GONE

        }

        else -> null
      }
    } else {
      val bitmap = loadBitmapFromUri(iconURI)
      if (bitmap != null) {
        iconView.setImageBitmap(bitmap)
      }
    }


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

fun loadBitmapFromUri(imageUri: String): Bitmap? {
  var bitmap: Bitmap? = null
  try {
    val url = URL(imageUri)
    val connection = url.openConnection()
    connection.connect()
    val inputStream = connection.getInputStream()
    bitmap = BitmapFactory.decodeStream(inputStream)
    inputStream.close()
  } catch (e: IOException) {
    e.printStackTrace()
  }
  return bitmap
}
