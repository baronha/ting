import { NativeModules, Platform, Image } from 'react-native';
import type { AlertOptions, ToastOptions } from './Type';
export * from './Type';

const LINKING_ERROR =
  `The package 'ting' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

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
  return Ting.toast(options);
}

export function alert(options: AlertOptions): void {
  convertIconFile(options);
  return Ting.alert(options);
}

export function dismissAlert(): void {
  return Ting.dismissAlert();
}

export function initialize(options: {
  alert?: AlertOptions;
  toast?: ToastOptions;
}): void {
  return Ting.initialize(options);
}
