export interface Icon {
  size?: number;
  uri?: string | number;
  tintColor?: string;
}

export interface ToastOptions {
  title: string;
  message?: string;
  titleColor?: string;
  messageColor?: string;
  /**
   * Defaults to `done`.
   */
  preset?: 'done' | 'error' | 'none';
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
   * custom icon
   *  Defaults to `null`.
   */
  icon?: Icon;
}

export interface AlertOptions {
  title: string;
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
}
