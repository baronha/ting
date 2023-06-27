import { NativeModules, Platform, Image } from 'react-native';
import type { Icon, ToastOptions } from './Type';
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

const convertIconFile = (icon: Icon['uri']): Icon['uri'] => {
  if (typeof icon === 'number') {
    return Image.resolveAssetSource(icon).uri;
  }
  return icon;
};

export function toast(options: ToastOptions): void {
  const iconURI = options?.icon?.uri;
  if (iconURI && options?.icon) options.icon.uri = convertIconFile(iconURI);

  return Ting.toast(options);
}
