// @flow

import React, { Component } from 'react'
import {
  View,
  Image,
  Text,
  StyleSheet,
} from 'react-native'
import colors from '../colors'

type Props = {
  avatarURL?: string,
  userName: string,
  height?: number, // Width will always be equal to the height
}

export default class Avatar extends Component<any, Props, any> {

  // Checks for the crappy default profile picture from canvas
  // If it's one of those things, returns null
  imageURL = () => {
    const url = this.props.avatarURL
    if (!url) return null

    // There are a few different forms that the default picture can take
    const defaults = ['images/dotted_pic.png', 'images%2Fmessages%2Favatar-50.png', 'images/messages/avatar-group-50.png']
    if (defaults.filter(d => url.includes(d)).length) {
      return null
    }

    return url
  }

  render () {
    const url = this.imageURL()
    const height = this.props.height || 40
    const width = height
    const borderRadius = Math.round(height / 2)
    const fontSize = Math.round(height / 3)
    if (url) {
      return (
        <View style={[styles.imageContainer, { height, width, borderRadius }]} accessibilityLabel=''>
          <Image
            source={{ uri: url }}
            style={{ height, width }}
          />
        </View>
      )
    } else {
      const altText = this.props.userName
      .split(' ')
      .map((word) => word[0])
      .filter((c) => c)
      .reduce((m, c) => m + c)
      .substring(0, 3)
      .toUpperCase()
      return (
        <View style={[styles.altImage, { height, width, borderRadius }]} accessibilityLabel=''>
          <Text style={[styles.altImageText, { fontSize }]}>{altText}</Text>
        </View>
      )
    }
  }
}

const styles = StyleSheet.create({
  imageContainer: {
    overflow: 'hidden',
  },
  altImage: {
    borderColor: colors.seperatorColor,
    borderWidth: StyleSheet.hairlineWidth,
    overflow: 'hidden',
    marginRight: global.style.defaultPadding,
    justifyContent: 'center',
    alignItems: 'center',
  },
  altImageText: {
    fontWeight: '600',
    backgroundColor: 'transparent',
  },
})
