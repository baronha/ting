import React from 'react';

import { StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { toast } from 'ting';

export default function App() {
  const showToast = () => {
    toast({
      title: 'Hey!',
      duration: 5,
      preset: 'error',
      icon: require('./toast.png'),
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
