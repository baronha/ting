package com.ting

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReadableMap

abstract class TingSpec internal constructor(context: ReactApplicationContext) :
  ReactContextBaseJavaModule(context) {
  abstract fun toast(RNOptions: ReadableMap)
  abstract fun alert(RNOptions: ReadableMap)
  abstract fun setup(options: ReadableMap)
  abstract fun dismissAlert()
}
