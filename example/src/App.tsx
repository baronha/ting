import React from 'react';

import { StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { alert, toast } from 'ting';

export default function App() {
  const showToast = () => {
    toast({
      title: 'Xin chào',
      message: 'Xin chào Việt Nam',
      duration: 5,
      preset: 'none',
      icon: {
        uri: require('./vietnam.png'),
      },
    });
  };

  const showAlert = () => {
    alert({
      title: '50 nghìn',
      message: 'Thanh toán thành công',
      duration: 5,
      preset: 'none',
      icon: {
        uri: require('./dong.png'),
      },
    });
  };

  return (
    <View style={style.container}>
      <TouchableOpacity
        activeOpacity={0.9}
        onPress={showToast}
        style={style.button}
      >
        <Text style={style.label}>Show Toast</Text>
      </TouchableOpacity>
      <TouchableOpacity
        activeOpacity={0.9}
        onPress={showAlert}
        style={style.button}
      >
        <Text style={style.label}>Show Alert</Text>
      </TouchableOpacity>
    </View>
  );
}

const style = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#333',
  },
  button: {
    padding: 12,
    backgroundColor: '#fff',
    width: '75%',
    marginHorizontal: 24,
    marginVertical: 24,
    alignItems: 'center',
  },
  label: {
    fontWeight: 'bold',
    color: '#000',
    textAlign: 'center',
  },
});
