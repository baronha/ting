package com.ting

import android.content.Context
import android.content.res.Resources
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Color
import android.graphics.PorterDuff
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
import com.facebook.react.bridge.Arguments.createMap
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.UiThreadUtil.runOnUiThread
import com.facebook.react.bridge.WritableMap
import com.hjq.window.EasyWindow
import java.io.IOException
import java.net.URL
import kotlin.math.roundToInt


class TingModule internal constructor(context: ReactApplicationContext) : TingSpec(context) {

  private var context: Context = context
  private val alertWindow = EasyWindow<EasyWindow<*>>(currentActivity)
  private val toastWindow = EasyWindow<EasyWindow<*>>(currentActivity)
  private var toastOptionInit: ReadableMap? = null
  private var alertOptionInit: ReadableMap? = null

  @ReactMethod
  override fun toast(RNOptions: ReadableMap) {
    // get container View
    val options = toastOptionInit?.let { mergeMaps(it, RNOptions) } ?: RNOptions

    val container = getContainerView(R.layout.toast, options, "toast")
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
  override fun alert(RNOptions: ReadableMap) {
    val options = alertOptionInit?.let { mergeMaps(it, RNOptions) } ?: RNOptions

    val container = getContainerView(R.layout.alert, options, "alert")
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
        setOutsideTouchable(true)
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
    if (alertWindow.isShowing) {
      runOnUiThread {
        alertWindow.cancel()
      }
    }
  }

  @ReactMethod
  override fun setup(options: ReadableMap) {
    val toastOption = options.getMap("toast")
    val alertOption = options.getMap("alert")
    if (toastOption != null) toastOptionInit = toastOption
    if (alertOption != null) alertOptionInit = alertOption

  }

  private fun getDuration(options: ReadableMap): Int {
    return if (options.hasKey("duration")) (options.getInt("duration") * 1000) else 3000
  }

  private fun getContainerView(
    view: Int,
    options: ReadableMap,
    contentType: String?
  ): LinearLayout {
    val inflater = LayoutInflater.from(context)
    val container = inflater.inflate(
      view, null
    ) as LinearLayout

    val title = options?.getString("title")
    val titleColor = options?.getString("titleColor")
    val message = options?.getString("message")
    val messageColor = options?.getString("messageColor")
    val preset = options?.getString("preset")
    val backgroundColor = options?.getString("backgroundColor")
    val borderRadius = if (options.hasKey("borderRadius")) options?.getInt("borderRadius") else null

    // init view
    val messageView: TextView = container.findViewById(R.id.message)
    val titleView: TextView = container.findViewById(R.id.title)
    val iconView: ImageView = container.findViewById(R.id.icon)

    // icon options
    val icon = options?.getMap("icon")
    val iconURI = icon?.getString("uri")

    // set container style
    val background = container.background as GradientDrawable

    if (isNumber(borderRadius)) {
      background.cornerRadius = convertInt2Size(borderRadius).toFloat()
      intArrayOf(Color.BLUE)
    }

    if (backgroundColor != null) {
      val color = intArrayOf(parseColor(backgroundColor), parseColor(backgroundColor))
      background.colors = color
    } else {
      val color = intArrayOf(Color.WHITE, Color.WHITE)
      background.colors = color
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

        "spinner" -> {
          val progressBar = ProgressBar(context)
          val progressSize: LinearLayout.LayoutParams =
            if (contentType == "toast") LinearLayout.LayoutParams(
              convertInt2Size(24),
              convertInt2Size(24)
            ) else LinearLayout.LayoutParams(
              LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT
            )

          iconView.visibility = ImageView.GONE
          progressBar.id = R.id.loading_spinner
          progressBar.layoutParams = progressSize
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
        val iconSize = if (icon?.hasKey("size") == true) icon.getInt("size") else null
        val tintColor = if (icon?.hasKey("tintColor") == true) icon.getString("tintColor") else null

        if (isNumber(iconSize)) {
          val size = convertInt2Size(iconSize)

          iconView.layoutParams.width = size
          iconView.layoutParams.height = size
        }
        if (tintColor != null) {
          val color = parseColor(tintColor)
          iconView.setColorFilter(color, PorterDuff.Mode.SRC_IN)
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

fun mergeMaps(map1: ReadableMap, map2: ReadableMap): WritableMap {
  val mergedMap: WritableMap = createMap()
  mergedMap.merge(map1)
  mergedMap.merge(map2)
  return mergedMap
}
