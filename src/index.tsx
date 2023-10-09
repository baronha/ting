import { NativeModules, Platform, Image } from 'react-native';
import type { AlertOptions, ToastOptions } from './Type';
export * from './Type';

const LINKING_ERROR =
  `The package 'ting' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n'

// @ts-expect-error
const isTurboModuleEnabled = global.__turboModuleProxy != null;

const TingModule = isTurboModuleEnabled
  ? require('./NativeTing').default
  : NativeModules.Ting;

const Ting = TingModule
  ? TingModule
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

const convertIconFile = (options: ToastOptions | AlertOptions): void => {
  const iconURI = options?.icon?.uri;
  if (options?.icon) {
    if (typeof iconURI === 'number') {
      options.icon.uri = Image.resolveAssetSource(iconURI).uri;
    }
  }
};

export function toast(options: ToastOptions): void {
  convertIconFile(options);
  Ting.toast(options);
}

export function alert(options: AlertOptions): void {
  convertIconFile(options);
  Ting.alert(options);
}

export function dismissAlert(): void {
  Ting.dismissAlert();
}

export function setup(options: {
  alert?: AlertOptions;
  toast?: ToastOptions;
}): void {
  convertIconFile(options?.alert as AlertOptions);
  convertIconFile(options?.toast as ToastOptions);
  return Ting.setup(options);
}
