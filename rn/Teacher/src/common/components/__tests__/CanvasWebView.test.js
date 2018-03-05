// @flow

import React from 'react'
import { NativeModules } from 'react-native'
import { shallow } from 'enzyme'
import CanvasWebView, { type Props } from '../CanvasWebView'

const template = {
  ...require('../../../__templates__/helm'),
}

describe('CanvasWebView', () => {
  let props: Props

  beforeEach(() => {
    jest.clearAllMocks()

    props = {
      scrollEnabled: true,
      navigator: template.navigator(),
    }
  })

  it('renders html', () => {
    const html = '<div>Hello, World!</div>'
    const tree = shallow(<CanvasWebView {...props} html={html} />)
    const webView = tree.find('WebView')
    expect(webView.props().source).toEqual({ html })
  })

  it('renders uri', () => {
    const uri = 'https://apple.com'
    const tree = shallow(<CanvasWebView {...props} source={{ uri }} />)
    const webView = tree.find('WebView')
    expect(webView.props().source).toEqual({ uri })
  })

  it('sends messages', () => {
    const onMessage = jest.fn()
    const tree = shallow(<CanvasWebView {...props} onMessage={onMessage} />)
    const webView = tree.find('WebView')
    webView.simulate('Message', { nativeEvent: 'hello' })
    expect(onMessage).toHaveBeenCalledWith('hello')
  })

  it('notifies when finished loading', () => {
    const onFinishedLoading = jest.fn()
    const tree = shallow(<CanvasWebView {...props} onFinishedLoading={onFinishedLoading} />)
    const webView = tree.find('WebView')
    webView.simulate('FinishedLoading')
    expect(onFinishedLoading).toHaveBeenCalled()
  })

  it('handles navigation', () => {
    const navigator = template.navigator({ show: jest.fn() })
    const tree = shallow(<CanvasWebView {...props} navigator={navigator} />)
    const webView = tree.find('WebView')
    const url = 'https://canvas.instructure.com/courses/1/assignments/1'
    webView.simulate('Navigation', { nativeEvent: { url } })
    expect(navigator.show).toHaveBeenCalledWith(url, {
      deepLink: true,
    })
  })

  it('sends errors', () => {
    const onError = jest.fn()
    const tree = shallow(<CanvasWebView {...props} onError={onError} />)
    const webView = tree.find('WebView')
    webView.simulate('Error', 'error')
    expect(onError).toHaveBeenCalledWith('error')
  })

  it('evaluates javascript', () => {
    const js = `console.log('Hello, World!');`
    const tree = shallow(<CanvasWebView {...props} />)
    tree.instance().evaluateJavaScript(js)
    expect(NativeModules.CanvasWebViewManager.evaluateJavaScript).toHaveBeenCalledWith(
      null,
      js,
    )
  })

  it('updates height to fit content if scroll disabled', async () => {
    const evaluateJavaScript = jest.fn(() => Promise.resolve(42))
    NativeModules.CanvasWebViewManager.evaluateJavaScript = evaluateJavaScript
    const tree = shallow(<CanvasWebView {...props} scrollEnabled={false} />)
    const webView = tree.find('WebView')
    await webView.simulate('FinishedLoading')
    tree.update()
    expect(tree.find('WebView').props().style.height).toEqual(42)
  })

  it('handles error when getting height', async () => {
    const onError = jest.fn()
    const evaluateJavaScript = jest.fn(() => Promise.reject('error'))
    NativeModules.CanvasWebViewManager.evaluateJavaScript = evaluateJavaScript
    const tree = shallow(<CanvasWebView {...props} scrollEnabled={false} onError={onError} />)
    const webView = tree.find('WebView')
    await webView.simulate('FinishedLoading')
    expect(onError).toHaveBeenCalledWith('error')
  })
})
