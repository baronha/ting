export interface Icon {
  size?: number;
  uri?: string | number;
  tintColor?: string;
}

export interface ToastOptions {
  title?: string;
  message?: string;
  titleColor?: string;
  messageColor?: string;
  /**
   * Defaults to `done`.
   */
  preset?: 'done' | 'error' | 'none' | 'spinner';
  /**
   * Duration in seconds.
   */
  duration?: number;
  haptic?: 'success' | 'warning' | 'error' | 'none';
  /**
   * Defaults to `true`.
   */
  shouldDismissByDrag?: boolean;
  /**
   * Change the presentation side.
   * Defaults to `top`.
   */
  position?: 'top' | 'bottom';
  /**
   * backgroundColor for toastView
   * Defaults to `null`.
   */
  backgroundColor?: string;

  /**
   * custom icon
   *  Defaults to `null`.
   */
  icon?: Icon;

  /**
   * progress color for spinner preset
   * @platform android
   */
  progressColor?: string;
}

export interface AlertOptions {
  title?: string;
  message?: string;
  titleColor?: string;
  messageColor?: string;
  /**
   * Defaults to `done`.
   */
  preset?: 'done' | 'error' | 'none' | 'spinner';
  /**
   * Duration in seconds.
   * Defaults to 3.
   */
  duration?: number;
  /**
   * @platform ios
   */
  haptic?: 'success' | 'warning' | 'error' | 'none';
  /**
   * Defaults to `true`.
   */
  shouldDismissByTap?: boolean;
  /**
   * backgroundColor for alertView
   * Defaults to `null`.
   */
  backgroundColor?: string;
  /**
   * borderRadius for alertView
   * Defaults to `24`.
   */
  borderRadius?: number;
  /**
   *  blur for backdrop
   * @platform android
   */
  blurBackdrop?: number;
  /**
   * @platform android
   * 0 -> 1
   * Defaults to 0.
   */
  backdropOpacity?: number;
  /**
   * custom icon
   */
  icon?: Icon;

  /**
   * progress color for spinner preset
   * @platform android
   */
  progressColor?: string;
}
