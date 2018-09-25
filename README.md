# ImagePickerCoordinator
[![License](https://img.shields.io/packagist/l/doctrine/orm.svg?style=flat-square)](https://cocoapods.org/pods/ImagePickerCoordinator)
[![Version](https://img.shields.io/badge/pod-v1.0.1-blue.svg?style=flat-square)](https://cocoapods.org/pods/ImagePickerCoordinator)

Yet another image picker coordinator based on TOCropViewController and ImagePicker
<p align="center">
<img src="Example/Screenshots/ImagePickerCoordinator.gif" height = "680" width = "320"/>
</p>

### How to use
Image picker has so simple usage, it can be reduced to 4 lines of code!

**NOTE:** Always remember to keep a strong reference to the coordinator in order to avoid 
the coordinator to be released too early
```
...
var imagePickerCoordinator:ImagePickerCoordinator
...
imagePickerCoordinator = ImagePickerCoordinator(fromController: .topMost)
imagePickerCoordinator.delegate = self
imagePickerCoordinator.start()
...
```

### Configuration
You can configure some of the ways the coordinator behaves.
- You can pre-select an image like this:
```
imagePickerCoordinator.selectedImage = myPreSelectedImage
```
- Remove the cropping or changing the style if needed.
```
imagePickerCoordinator.cropStyle = .circular
imagePickerCoordinator.cropStyle = nil // Removes the cropping flow at the end of the image selection
```
- Avoid the user to clear an image from the coordinator
```
imagePickerCoordinator.canClearSelectedImageIfAny = false
```


### Delegate 
The delegate can tell you when an image has been selected, cleared or when the coordinator has been cancelled without selecting any image.
If you need more delegate methods ask for it or create a pull request!

### More
Suggestions? Features? Threats? Let me know!
