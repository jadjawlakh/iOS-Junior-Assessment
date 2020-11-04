# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Imagine' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Imagine
  pod 'MobAdSDK', '1.3.8'
  
  # Target the Notification Content Extension target
  target 'NotificationContentExtension' do
    end

end

post_install do |installer|
    #Specify what and where has to be added
    targetName = 'MobAdSDK'
    
    # Key & Value to allow the use of UIApplication shared instance
    keyApplicationExtensionAPIOnly = 'APPLICATION_EXTENSION_API_ONLY'
    valueApplicationExtensionAPIOnly = 'NO'

    #Find the pod which should be affected
    targets = installer.pods_project.targets.select { |target| target.name == targetName }
    target = targets[0]

    #Do the job
    target.build_configurations.each do |config|
        config.build_settings[keyApplicationExtensionAPIOnly] = valueApplicationExtensionAPIOnly
    end
end

