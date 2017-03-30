
# React Native Image Picker [![npm version](https://badge.fury.io/js/react-native-dynamic-fonts.svg)](https://badge.fury.io/js/react-native-dynamic-fonts) [![npm](https://img.shields.io/npm/dt/react-native-dynamic-fonts.svg)](https://www.npmjs.org/package/react-native-dynamic-fonts) ![MIT](https://img.shields.io/dub/l/vibe-d.svg) ![Platform - Android and iOS](https://img.shields.io/badge/platform-Android%20%7C%20iOS-yellow.svg)

A React Native module that allows you to load fonts dynamically at runtime via base64 encoded TTF or OTF, like so:

## Table of contents
- [Install](#install)
- [Usage](#usage)
- [Options](#options)
- [Response object](#the-response-object)

## Install

`npm install react-native-dynamic-fonts@latest --save`

### Automatic Installation

`react-native link`

### Manual Installation

#### iOS

1. In the XCode's "Project navigator", right click on your project's Libraries folder ➜ `Add Files to <...>`
2. Go to `node_modules` ➜ `react-native-dynamic-fonts` ➜ `ios` ➜ select `RCTDynamicFonts.xcodeproj`
3. Add `libRCTDynamicFonts.a` to `Build Phases -> Link Binary With Libraries`
4. Compile and have fun

#### Android
1. Add the following lines to `android/settings.gradle`:
    ```gradle
    include ':react-native-dynamic-fonts'
    project(':react-native-dynamic-fonts').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-dynamic-fonts/android')
    ```
    
2. Add the compile line to the dependencies in `android/app/build.gradle`:
    ```gradle
    dependencies {
        compile project(':react-native-dynamic-fonts')
    }
    ```
    
3. Add the import and link the package in `MainApplication.java`:
    ```java
    import com.imagepicker.ImagePickerPackage; // <-- add this import

    public class MainApplication extends Application implements ReactApplication {
        @Override
        protected List<ReactPackage> getPackages() {
            return Arrays.<ReactPackage>asList(
                new MainReactPackage(),
                new DynamicFontsPackage() // <-- add this line
            );
        }
    }
    ```

### Example of how to use

To load a font dynamically, you must first have a base64 string of your font file (TTF or OTF):
```javascript
import { loadFont } from 'react-native-dynamic-fonts';

...

loadFonts('nameOfFont', base64FontString, 'ttf').then(function(name) {
	console.log('Loaded font successfully. Font name is: ', name);
});

...

```


#### Note

On iOS, it isn't possible to specify the font name. For this reason BOTH Android and iOS return the ACTUAL registered font name. For Android this is whatever you pass in, for iOS it is whatever is embedded in the font. I suggest you always use the full name embedded in the font to avoid issues.

### Options

option | iOS  | Android | Info
------ | ---- | ------- | ----
name | Not used | Used | Specify registered font name (doesn't work for iOS)
data | Used | Used | This can be a data URI or raw base64... if it is raw base64 type must be specified, but defaults to TTF (data URI mime: font/ttf or font/otf)
type | Used | Used | Specify the type of font in the encoded data (ttf or otf)

### The Response

The ACTUAL name the font was registered with. Use this for your fontFamily.
