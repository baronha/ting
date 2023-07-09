/* eslint-disable react-native/no-inline-styles */
import React from 'react';

import {
  SafeAreaView,
  StatusBar,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
  Dimensions,
  GestureResponderEvent,
  Image,
} from 'react-native';
import { alert, toast, dismissAlert } from 'ting';
import MasonryList from '@react-native-seoul/masonry-list';
import image from './image';

const { width } = Dimensions.get('window');

export default function App() {
  const onDismissAlert = () => {
    dismissAlert();
  };

  const renderItem = ({ item, i }: { item: any; i: number }) => {
    const { onPress, title, subTitle, backgroundColor, icon } = item;
    const firstLeftItem = i === 1;
    return (
      <TouchableOpacity
        key={i}
        onPress={onPress}
        activeOpacity={0.8}
        style={[
          style.item,
          { backgroundColor },
          firstLeftItem ? { marginTop: '30%' } : {},
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
        ListFooterComponent={
          <TouchableOpacity
            activeOpacity={0.9}
            onPress={onDismissAlert}
            style={style.footerButton}
          >
            <Text style={style.footerTextButton}>Dismiss Alert</Text>
          </TouchableOpacity>
        }
        showsVerticalScrollIndicator={false}
        style={style.list}
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
    subTitle: `default`,
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
    icon: image.wine,
    subTitle: `preset = 'error'`,
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
        duration: 10,
        title: 'Xin chào',
        titleColor: '#D60A2E',
        message: 'Việt Nam mãi đỉnh 🇻🇳',
        messageColor: '#000000',
        icon: {
          uri: image.vietnam,
        },
      }),
  },
  {
    title: 'BOTTOM',
    backgroundColor: '#F2EBFF',
    subTitle: `position = 'bottom'`,
    icon: image.cactus,
    onPress: () =>
      toast({
        title: 'Đáy xã hội',
        position: 'bottom',
        message: 'Ở đây nè',
        icon: {
          uri: image.cactus,
        },
      }),
  },
  {
    title: 'ALERT DONE',
    backgroundColor: '#F4FECC',
    icon: image.clapping,
    subTitle: `default`,
    onPress: () =>
      alert({
        title: 'Xong rồi!',
        message: 'Hoàn thành thử thách',
      }),
  },
  {
    title: 'ALERT ERROR',
    backgroundColor: '#F7C56E',
    icon: image.bug,
    subTitle: `default`,
    onPress: () =>
      alert({
        preset: 'error',
        title: 'Thất bại!',
        message: 'Thử lại đi fen',
      }),
  },
  {
    title: 'ALERT\nCUSTOMIZE',
    backgroundColor: '#fff',
    subTitle: 'Customize the icon of the alert with an image',
    icon: image.dong,
    onPress: () =>
      alert({
        title: 'Thành công',
        message: 'Phạt 50 ngàn',
        icon: {
          uri: image.dong,
        },
      }),
  },
  {
    title: 'ALERT\nLOADER',
    backgroundColor: '#FEE6CC',
    subTitle: `preset = 'spinner'`,
    icon: image.fire,
    onPress: () =>
      alert({
        title: 'Thành công',
        message: 'Phạt 50 ngàn',
        preset: 'spinner',
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
    textAlign: 'center',
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
  footerButton: {
    backgroundColor: '#fff',
    marginBottom: width / 2,
    padding: 20,
    alignItems: 'center',
    borderRadius: 20,
    marginTop: 1,
  },
  footerTextButton: {
    fontWeight: 'bold',
    color: 'rgba(0,0,0,.7)',
    textAlign: 'center',
  },
});
