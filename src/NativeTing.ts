import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  toast(options: Object): void;
  alert(options: Object): void;
  dismissAlert(): void;
  setup(options: Object): void;
}

export default TurboModuleRegistry.getEnforcing<Spec>('Ting');
