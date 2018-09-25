Pod::Spec.new do |spec|
  spec.name         = 'ImagePickerCoordinator'
  spec.homepage     = "https://github.com/Machipla/ImagePickerCoordinator"
  spec.version      = '1.0.0'
  spec.platform     = :ios, "9.0"
  spec.authors      = 'Mario Chinchilla'
  spec.summary      = 'The typical flow for picking an image now encapsulated in a coordinator!'
  spec.license      = { :type => "MIT", :file => "LICENSE.md" }
  spec.source       = { :git => 'https://Machipla@github.com/Machipla/ImagePickerCoordinator.git', :tag => "#{spec.version}" }
  spec.swift_version = '4.0'
  
  spec.source_files     = "Sources/**/*.swift"
  spec.resource_bundle  = { "ImagePickerCoordinator" => "Sources/*.bundle/**/*.lproj" }

  spec.dependency 'CropViewController'
  spec.dependency 'ImagePicker'

  spec.framework = 'MobileCoreServices'
end