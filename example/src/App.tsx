import React from 'react';

import {
  SafeAreaView,
  StatusBar,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
  // Dimensions,
  GestureResponderEvent,
  Image,
} from 'react-native';
import { toast } from 'ting';
import MasonryList from '@react-native-seoul/masonry-list';
import image from './image';

// const { width, height } = Dimensions.get('window');

export default function App() {
  const renderItem = ({ item, i }: { item: any; i: number }) => {
    const { onPress, title, subTitle, backgroundColor, icon } = item;
    const leftItem = i % 2 !== 0;
    return (
      <TouchableOpacity
        key={i}
        onPress={onPress}
        activeOpacity={0.8}
        style={[
          style.item,
          { backgroundColor },
          leftItem ? { top: '25%' } : {},
        ]}
      >
        <View style={style.iconView}>
          <Image source={icon} style={style.icon} />
        </View>
        <Text style={style.label}>{title}</Text>
        <Text style={style.subLabel}>{subTitle}</Text>
      </TouchableOpacity>
    );
  };

  return (
    <SafeAreaView style={style.container}>
      <StatusBar backgroundColor={'#000'} barStyle="light-content" />
      <View style={style.header}>
        <Text style={style.title}>Ting</Text>
        <Text style={style.subTitle}>Easy toast for React Native</Text>
      </View>
      <MasonryList
        containerStyle={style.list}
        data={DATA}
        renderItem={renderItem}
        keyExtractor={(_, index) => `item-${index}`}
      />
    </SafeAreaView>
  );
}

type ItemType = {
  title: string;
  backgroundColor: string;
  subTitle?: string;
  icon?: number;
  onPress: (event: GestureResponderEvent) => void;
};

const DATA: ItemType[] = [
  {
    title: 'DONE',
    subTitle: `preset = 'done'`,
    backgroundColor: '#9EE8AE',
    icon: image.balloon,
    onPress: () =>
      toast({
        title: 'Tuyệt zời!',
        message: 'Xử lý thành công',
      }),
  },
  {
    title: 'ERROR',
    icon: image.fire,
    backgroundColor: '#FD966A',
    onPress: () =>
      toast({
        preset: 'error',
        title: 'Lỗi rồi',
        message: 'Xin mời thử lại!',
      }),
  },
  {
    title: 'CUSTOMIZE',
    backgroundColor: '#FFCDCD',
    icon: image.vietnam,
    subTitle: 'Customize the icon of the toast with an image',
    onPress: () =>
      toast({
        title: 'Xin chào',
        titleColor: '#D60A2E',
        message: 'Xin chào Việt Nam nha!',
        messageColor: '#000000',
        icon: {
          uri: image.vietnam,
        },
      }),
  },
  {
    title: 'BOTTOM',
    backgroundColor: '#FDFEB0',
    subTitle: `position = 'bottom'`,
    icon: image.cactus,
    onPress: () =>
      toast({
        title: 'Đáy xã hội',
        position: 'bottom',
        message: 'Ở đây nè',
        icon: {
          uri: image.vietnam,
        },
      }),
  },
];

const style = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#000',
  },

  item: {
    // height: HEIGHT,
    justifyContent: 'center',
    alignItems: 'center',
    margin: 1,
    // marginTop: 2,
    borderRadius: 20,
    flex: 1,
    paddingVertical: 48,
    // aspectRatio: 3 / 4,
  },
  header: {
    padding: 12,
  },
  title: {
    color: '#fff',
    fontWeight: 'bold',
    fontSize: 24,
    textAlign: 'center',
  },
  subTitle: {
    color: '#ffffff92',
    fontWeight: '500',
    textAlign: 'center',
    marginTop: 6,
  },

  list: {
    paddingTop: 24,
  },
  label: {
    fontWeight: 'bold',
    fontSize: 18,
    marginTop: 24,
  },
  icon: {
    width: 32,
    height: 32,
  },
  iconView: {
    backgroundColor: 'rgba(0,0,0,.1)',
    padding: 12,
    borderRadius: 99,
  },
  subLabel: {
    marginTop: 4,
    fontWeight: '300',
    color: 'rgba(0,0,0,.7)',
    textAlign: 'center',
  },
});
