package com.ting

import android.content.Context
import android.content.res.Resources
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Color
import android.graphics.drawable.AnimatedVectorDrawable
import android.graphics.drawable.GradientDrawable
import android.os.Handler
import android.os.Looper
import android.view.Gravity
import android.view.LayoutInflater
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.ProgressBar
import android.widget.TextView
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.UiThreadUtil.runOnUiThread
import com.hjq.window.EasyWindow
import java.io.IOException
import java.net.URL
import kotlin.math.roundToInt


class TingModule internal constructor(context: ReactApplicationContext) : TingSpec(context) {

  private var context: Context = context
  private val alertWindow = EasyWindow<EasyWindow<*>>(currentActivity)
  private val toastWindow = EasyWindow<EasyWindow<*>>(currentActivity)

  @ReactMethod
  override fun toast(options: ReadableMap) {
    // get container View
    val container = getContainerView(R.layout.toast, options)
    val duration: Int = getDuration(options)

    var toastAnim = R.style.ToastTopAnim
    val position: Int = when (options?.getString("position")) {
      "bottom" -> {
        toastAnim = R.style.ToastBottomAnim
        Gravity.BOTTOM
      }

      else -> {
        Gravity.TOP
      }
    }

    runOnUiThread {
      toastWindow.cancel()
      toastWindow.apply {
        setDuration(duration)
        contentView = container
        setGravity(position)
        setYOffset(48)
        setAnimStyle(toastAnim)
        setOutsideTouchable(true)
        setOnClickListener(R.id.toast,
          EasyWindow.OnClickListener { toast: EasyWindow<*>, _: LinearLayout? ->
            val shouldDismissByTap =
              if (options.hasKey("shouldDismissByDrag")) options.getBoolean("shouldDismissByDrag") else true
            if (shouldDismissByTap) toast.cancel()
          })
      }.show()
    }
  }

  @ReactMethod
  override fun alert(options: ReadableMap) {
    val container = getContainerView(R.layout.alert, options)
    val duration: Int = getDuration(options)
    val blurBackdrop: Int =
      if (options.hasKey("blurBackdrop")) options.getInt("blurBackdrop") else 0

    var backdropOpacity: Double =
      if (options.hasKey("backdropOpacity")) options.getDouble("backdropOpacity") else 0.0

    if (backdropOpacity < 0) backdropOpacity = 0.0
    else if (backdropOpacity > 1) backdropOpacity = 1.0

    runOnUiThread {
      alertWindow.cancel()
      alertWindow.apply {
        setDuration(duration)
        contentView = container
        setAnimStyle(R.style.AlertAnim)
        setOutsideTouchable(false)
        setGravity(Gravity.CENTER)
        setBlurBehindRadius(blurBackdrop)
        setBackgroundDimAmount(backdropOpacity.toFloat())
        setOnClickListener(R.id.alert,
          EasyWindow.OnClickListener { alert: EasyWindow<*>, _: LinearLayout? ->
            val shouldDismissByTap =
              if (options.hasKey("shouldDismissByTap")) options.getBoolean("shouldDismissByTap") else true
            if (shouldDismissByTap) alert.cancel()
          })

      }.show()
    }
  }

  @ReactMethod
  override fun dismissAlert() {
    if (alertWindow != null && alertWindow.isShowing) {
      runOnUiThread {
        alertWindow.cancel()
      }
    }
  }


  private fun getDuration(options: ReadableMap): Int {
    return if (options.hasKey("duration")) (options.getInt("duration") * 1000) else 3000
  }

  private fun getContainerView(view: Int, options: ReadableMap): LinearLayout {
    val inflater = LayoutInflater.from(context)
    val container = inflater.inflate(
      view, null
    ) as LinearLayout

    val title = options?.getString("title")
    val titleColor = options?.getString("titleColor")
    val message = options?.getString("message")
    val messageColor = options?.getString("messageColor")
    val preset = options?.getString("preset")
    val borderRadius = if (options.hasKey("borderRadius")) options?.getInt("borderRadius") else null

    // init view
    val messageView: TextView = container.findViewById(R.id.message)
    val titleView: TextView = container.findViewById(R.id.title)
    val iconView: ImageView = container.findViewById(R.id.icon)

    // icon options
    val icon = options?.getMap("icon")
    val iconURI = icon?.getString("uri")
    val iconSize = if (icon?.hasKey("size") == true) icon.getInt("size") else null
    // set container style


    if (isNumber(borderRadius)) {
      val background = container.background as GradientDrawable
      background.cornerRadius = convertInt2Size(borderRadius).toFloat()
    }

    // set title
    titleView.text = title
    if (titleColor != null) titleView.setTextColor(parseColor(titleColor))

    // check message
    if (message == null) {
      messageView.visibility = TextView.GONE
    } else {
      messageView.text = message
    }

    if (messageColor != null) messageView.setTextColor(parseColor(messageColor))

    // Icon by preset
    if (iconURI == null) {
      when (preset) {
        "done" -> {
          loadDoneIcon(iconView)
        }

        "error" -> {
          iconView.setImageResource(R.drawable.error)
        }

        // for alert view
        "spinner" -> {
          val progressBar = ProgressBar(context)
          iconView.visibility = ImageView.GONE
          progressBar.id = R.id.loading_spinner
          progressBar.layoutParams = LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT
          )
          container.addView(progressBar, 0)
        }

        "none" -> {
          iconView.visibility = ImageView.GONE
        }

        else -> {
          loadDoneIcon(iconView)
        }
      }
    } else {
      val bitmap = loadBitmapFromUri(iconURI)
      if (bitmap != null) {
        iconView.setImageBitmap(bitmap)
        if (isNumber(iconSize)) {
          val size = convertInt2Size(iconSize)

          iconView.layoutParams.width = size
          iconView.layoutParams.height = size
        }
      } else {
        loadDoneIcon(iconView)
      }
    }

    return container
  }

  override fun getName(): String {
    return NAME
  }

  companion object {
    const val NAME = "Ting"
  }

  private fun loadDoneIcon(iconView: ImageView) {
    iconView.setImageResource(R.drawable.done)
    val avd = iconView.drawable as AnimatedVectorDrawable
    val handler = Handler(Looper.getMainLooper())
    handler.postDelayed({
      avd.start()
    }, 300)
  }


}

fun isNumber(value: Any?): Boolean {
  return value != null && (value is Int || value is Long || value is Float || value is Double)
}

fun parseColor(hexColor: String): Int {
  val fallbackColor = Color.BLACK
  val color = try {
    Color.parseColor(hexColor)
  } catch (e: IllegalArgumentException) {
    fallbackColor
  }
  return color
}

fun convertInt2Size(number: Int?): Int {
  return (number!! * Resources.getSystem().displayMetrics.density).roundToInt()
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
