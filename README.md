
# React-Native-Couchbase-Lite

React-Native-Couchbase-Lite is a React Native module providing an easy way to create offline-first, lightweight and performant hybrid mobile application for both iOS and Android platforms. This is an all-native wrapper over Couchbase Lite, which is a document-oriented database running right on the mobile devices.

## Getting started

#(Currently npm install will not work. Project isn't uploaded to npm.)

`$ npm install react-native-couchbase-lite --save`

or

`$ yarn add react-native-couchbase-lite`

### Mostly automatic installation

`$ react-native link react-native-couchbase-lite`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-couchbase-lite` and add `RNReactNativeCbl.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNReactNativeCbl.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNReactNativeCblPackage;` to the imports at the top of the file
  - Add `new RNReactNativeCblPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-couchbase-lite'
  	project(':react-native-couchbase-lite').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-couchbase-lite/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-couchbase-lite')
  	```

## Usage
```javascript
import CouchbaseLite, { CBLConnection, CBLConnector } from 'react-native-couchbase-lite'

const cblConnection = new CBLConnection({
  dbName: 'mydb',
  syncGatewayUrl: 'http://sg.dummyapp.com/mydb',
  views: { ... },
})

export default class App extends React.Component {
  onButtonClicked() {
    CouchbaseLite.createDocument({ title: 'New Title', text: 'Description' })
  }

  render() {
    return (
      <CBLConnector connection={cblConnection}>
        ...
      </CBLConnector>
    )
  }
}
To be used differently
```
