// export type ToastMargin = {
//   top?: number;
//   bottom?: number;
//   right?: number;
//   left?: number;
// };

// export type ToastLayout = {
//   iconSize?: number;
//   margin?: ToastMargin;
// };

export interface Icon {
  size?: number;
  uri?: string | number;
  tintColor?: string;
}

export interface ToastOptions {
  title: string;
  message?: string;
  /**
   * Defaults to `done`.
   */
  preset?: 'done' | 'error' | 'none'; // TODO custom option
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
   * @platform ios
   */
  direction?: 'top' | 'bottom';

  /**
   * custom icon
   */
  icon?: Icon;
}
