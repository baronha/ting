import React from 'react';

import { StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { alert, toast } from 'ting';

export default function App() {
  const showToast = () => {
    toast({
      title: 'Xin chào',
      message: 'Xin chào Việt Nam',
      duration: 5,
      // position: 'bottom',
      preset: 'done',
      // icon: {
      //   uri: "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxAQEBAOEBAVFRUVEBUQFRAQFRgWEBISFRYWFhUWFhcYHSggGRslGxYVIjIhJSkrLi4uFx8zODMsNygtMSsBCgoKDg0OGhAQGisdIB0tLS0rKy0tLS0tKy0tLS0tLSstLS0tLS0tLS0tMC0tLS0tLS0rKy0tKy0tLS0tLSstLf/AABEIAOEA4QMBIgACEQEDEQH/xAAcAAEAAgMBAQEAAAAAAAAAAAAABgcBBQgEAwL/xABAEAACAgACBgYHBQcDBQAAAAAAAQIDBBEFBiExQWEHEjJRcZETIkJigaGxFFJywdEjM0NjgrLCkqKjRFOz4fD/xAAaAQEAAwEBAQAAAAAAAAAAAAAAAQMFAgQG/8QAJxEBAAICAgICAQMFAAAAAAAAAAECAxEEEiExIkFRI2GBQnGRobH/2gAMAwEAAhEDEQA/ALxAAAAAAAAAAAA+WIxEK4uU5KMVvlJpLzYkfUES0n0g4CnNRm7WuFSzXm9hGsb0qWPNU4ZLudss35R/Uotycdfco7QtIFK4jpG0jLdOuH4K0/7mzxT120m/+rl8I1r6RKZ52P8AEue8L3BQ8NddJL/q5/GNb+sT2UdIeko77YT/AB1x/wAchHOp+JO8LrMlVYLpTuX77DQlzrk4vyef1JHo7pHwNuSm5VP+YvV81mW15OK3267QmQPPhMbVdHr1WRmu+DTXyPQXxO0gAJAAAAAAAAAAAAAAAAAAwAPLpHSNOHg7brIwiuMnv5LvZGNb9eqsJnTTlbfuy/h185tb37q+RU2ldK34qbtvsc5cM+zHlGO5HjzcutPEeZczbSd6wdJ0nnDBV5Ld6a1ZvxjD9fIgWkNJ34iXXvunY/fexeCWxfBHlBm5M18nuVczMgAKkAAAAAAAAPthMZbTLr1WShJe1CTi/lvJxoDpMvryhi4elju9LBKNq8UvVl8MiAgsplvSfjKYmYdDaH01h8XD0lFikuK3Tj4xe1GwOcMFjLaJq2mcoSW6UXk/j3lo6odIcLurRjMoWbFG1bK5+P3ZfLw3Glh5lb+LeJdxbafgwmZPa7AAAAAAAAAAAAMAG8tpWWvWvjzlhMHL3bL1vffCv85eQ6RtcnnLA4aW7ZdbH/xxf1fwK2M3lcr+iiu1hvPb8+8AGc4AAAAAAAAAAAAAAAAAABONSNep4dxw2Kk5UvZGx7Z0+PfD5otyq2MoqUWmms01uafcc1k26PtcXhpxwuIlnTJ5Rm99Mn/g/ke/i8qY+N3dbflcIMRlntXmZNRYAAAAAAAAwQ7pE1o+yVegql+2ti8sv4de5zfPgvj3En0pjoYemy+x5RhFyfPLclzZz/pjSU8VfZiLO1OWeX3Y+zFckjx8vN0rqPcubTp42wAZCoAAAAAAAAAAAAAAAAAAAA+kaJtdZQm195Rk4+aWQiNj5gAC0ujHWn0iWAvl68VnTJ+3Fb4Z96W3ms+4sU5sw18q5wtg8pQkpRkt6ktqL91Y0zHG4au+O9rqzj92a7SNXh5+0dZ9wsrO22AB7nYAAAB8sTdGuErJPKMYuTfJLNjYrTpb03nKvAQexJW25d77EX/d5FcHq0rjpYi+7ES32WSn4L2V8FkvgeUwc2TvebKZncgAKkAAAAAAAAAAAAAAAABhmSyOj/UnrdTG4uGzZKqmS3905p+aRZixTktqExG351B1H66jjMXD1d9dMlvXCc19EWdGCSSSSSWSS2JI/SMm1iw1x11C2I0rjpO1YqVTx1MVGUWvSxislOLeXWy708vFFXl0dJ2koVYGdTa6937OEeLWacn4JfVFLmZzK1jJ4V39hNOi7TfoMV9mk/Uv2LPcrV2fNbPHIhZ+q7HGUZReTi1JNb1KLzT80efHeaWi34cxOpdKGTX6C0isThqcQvbgpNd0t0l55mwN+J3G14ACQIn0maQ9DgLIp5O1qpeD2y+SJYVb0xYvOzDULhGVrXN5RX+R5+TbrjmUWnwroAGIpAAAAAAAAAAAAAAAADBksfUDUjrdTGYuOzZKumXF71Oa+iLMWK2S2oTEbZ6P9SOt1MZi4bNkqqZLf3TmvoizkgkZNrFirjrqFsRoNPrNrBTgaXbY85PZCtdqcuXLmNZtYKcDS7bHnJ7IVrtTl3LlzKO01pa7GXSvulm3sUfZhHhGK4L6lPJ5MY41HtFraNNaXuxl0r7pZt7EvZhHhGK4I8IBkTMzO5VAAIFr9EOkOth7cO3+7s6y/DP/ANplgFNdFOL6mPdfCymS/qi1JfLrFym1xLdsUfstrPgAB6XQUr0o39bSM4/cqrh5py/yLpKJ6QJ56Txf44Lyrgjxc6f0/wCXF/SPgAyVYAAAAAAAAAAAAAAFj9H+pHWcMbi47O1VRJb+6c/yXxLMWK2S2oTEbNQNR+s4YzFx2LKVVMuL4Tmvoiz0gkZNrFirjrqFsRoNPrNrDTgaXbY85PZCtdqcu7w5jWXWGnA0u2zbJ7IVp+tOXdyXeyjtNaWuxl0r7pZt7orswjwjFcEU8nkxjjUe0Wto01pe7GXSvulnJ7orswjwjFcEeEAyJmZncqgAEAAAN1qXf6PSGDl/OUPhNOH5l+o510JPq4rCy7sTS/8AkidFGpwJ+Mwsp6AAe92wURr9HLSeL/HF+dcGXwUl0nU9XSVr+/XXP/b1f8Txc6P04/u4v6RUAGSrCZak6jvGx+0XycKc2oqPbsa3tPhHnvfIhjOgdUup9hwvU7PoYZZeG09XExVyX+X06rG5aPFdG2AlBxgrISy2TU3J581LNMrHWPV+7A2+itWae2FqXqWL8n3o6AyNfpzRFOMplRdHNPdJdqEuEovgz3ZuJS0fGNS7mrnkG21k0BdgbnVas4vNwtXZsj+T70akyLVms6lUAAgACx+j/Uhvq43Fw2bJVUy3v35r6L4lmLFbJbUJiNnR/qQ5OONxcdnaqpfHunNfRfFlnpBIybWLFXHXULYjQafWbWGnAUu2zbJ7IVJ+tOXdyXe+A1m1hpwFLtsecnshUu1OXdyXe+BR+m9L3Yy6V90s29iiuzCP3Yrgink8mMcaj2i1tMaa0tdjLZX3Szb3RXZhH7sVwR4QDImZmdyqAAQAAAAAD2aGjnicMu/E0r/kidFnP+p9PX0hg4/z4y/0Zy/I6ANTgR8ZlZT0AA97tgqvphwmV2Gv+9XKtvnF9ZfVlqkN6UsB6XAuxLbVNWf09mXyZ5+TXtjlFvSmgAYikJv0fa4/ZWsLiH+xk/Vn/wBqT7/c+hCAd48k0tuExOnSsJJpNPNNZprc0foqHULXV4ZxwuJlnS9kLHvp5P3PoW7CSaTTzTWaa3NG1hzVyV3C2J21+nNEU4ymVF0c09zXahLhKL7yj9ZNAXYG51WrNPbC1L1bI/k+9HQJrtN6IpxlMqLo5p7U/ahLhKL7zjkceMkbj2i1dueQbXWXQNuAudVu2LzcLfZnFceTXFcCZdH2pPW6uNxcNnaqpktr7pzT+S+Jl0wXtfppXFZ3o6PtSXLq43FwyXaqpktr7pzX0RZ6QSMmxixVx11C2I0Gn1n1hpwFLtsecnshUu1OXLkuL4DWfWCnAU+lsecnmq612py5clxfAo/Tel7sXdK+6WbexRXZhHhGPIp5PJjHGo9otbRpvS92MulfdLNvYorswjwjHkeAAyJmZncqgAEAAAAAAAACXdFuE9JpCM+FdU5/F5RX1ZdJXXQ/gMqr8S125quL5R3/ADZYps8OvXFH7ra+gAHqdB58fhY3VWUy3Tg4PwayPQCJjfgc3Y7CyptspmspQnKD8YvI+JPuljQvo74Y2C9W3KFmXCyKyi/jFZf0kBMHLSaXmqmY1IACtATnUHXV4ZxwuJk3S3lCx7XS3wfufQgwO8eS2O24InTpWMk0mnmms01ua5H6Kh1C11eGccLiZN0t5Qse11N8H7n0LcjJNJp5prNNbmu82sOauSu4XRO3nxuBquUVbXGajJTSms8pLc0ekyC3SQ0+s2sFOBp9LY85PNQrXanLlyWzNjWbWCnA0u2x5yeyFa7U5cuXMo7TWlrsZdK+6WbexR9mEeEYrgjy8nkxjjUe3NraNNaWtxl0r7pZt7FH2YR4RjyPCAZEzMzuVQACAAAAAAAAACWexLPhl3vuBK+jjQv2nGRsks66MrZdzmv3a89vw5nWOk3tEQRG1r6saM+y4SijjGCcvxvbL5m1MGT6CsajULwAEgAANdp7RUMXh7MPPdKOx/dkuy/gygMdhJ0WzpsWUoScGua/+z+J0eQDpO1W9ND7dTH9pCOVkV/ErXtfij9PBHi5mHvXtHuHFo2qgAGSrAAAJzqDrq8M44XEyzpbyhY99LfB+59CDA7x5LY7bhMTp0rGSaTTzTWaa3NM1Os2sFOBpdtjzk9kK12py7ly5lZaoa9TwdcqLouytRfo8n60JcI5v2H8iN6a0tdjLpX3Szk90V2YR4RiuCNG/Njp8fc/6dzfwaa0tdjLpX3Szk9iXswjwjFcF9TwgGZMzM7lWAAgAAAAAAAAAABmEHJqKWbbSSW9tvJIvfUzQSwWFhW1+0l69j998PhuIX0X6r9eS0hdH1Y5+hi+Mtzsfhw8+CLTRqcLDqO8/wALKR9sGQD3uwAAAAAMNGQBUHSHqg8NOWLw8c6ZPOcV/Ck+P4H8mQc6UtqjKLjJJprJp7U0+BUOvOpE8K5YnDRcqXtlBbZU/rDnwMvlcXU96q7V+4QkAHgcAAAAAAAAAAAAAAAAAAAEo1H1UnjrevNNUQfry++/uR/N8PiNTdT7cdNWTzhQn61m6U/dh+b4Fz4HB101xqqiowislFbkj28bjdvlb1/11Wr6U1RhGMIpKKSSS3JLcj6AGstAAAAAAAAAAAMSjnsZkAV1rh0eKzrX4JKM98qHshP8D9l8t3gVjicPOqTrshKEk8nGaykvgdJmp07q9hsbHq3VpvLZYtlkfB/keHPw4t5r4lxNdufgTTT/AEdYqjOeH/bw35LZcl+H2vh5ENsrlFuMouLW+Mk1JeKe1GbfHak/KNK5iYfkAHAAAAAAAAAAJZ7F5Le/AlegNQsZicpzj6Ct7etasrGvdhv88jumO151WCIRWEHJqMU228kkm23yRYeqHR3KXVvxy6sd8cP7UudjW78PnluJpq7qnhcEk64dafG6e2b8O74G/NHDwor5v/hZFPy+dNUYRUIRSilkopZJLkj6AHvdgAAAAAAAAAAAAAAAAAAweDSehsNiVlfTCfOS9ZeEt6NgCJiJ8SK/0l0X4eWbotnX7svXj+pGsb0a46H7t12LlLqy8mvzLlB57cTFb6056woHEap6Qr7WDt/oSmv9rZ456IxUe1hb141T/Q6KBTPAr9SjpDnSOicS92GufhVP9D10araQn2cHb/VHq/3ZHQAIjgV+5OkKWwfRxpCfbjXWvfnm/KP6kk0b0W1LJ4i+U/drXVj5vaWKC6vDxV+tp6w1WidXsJhcvQ0Ri/vtZz/1PabQyD0xWI8Q6YMgEgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP//Z",
      // },
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
