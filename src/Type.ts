export type ToastLayout = {
  iconSize?: {
    width: number;
    height: number;
  };
};

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
  position?: 'top' | 'bottom';
  layout?: ToastLayout;
}
