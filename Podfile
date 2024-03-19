# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'FilaFacil' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FilaFacil

  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  #pod 'Firebase/InstanceID'
  #pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  pod 'IQKeyboardManagerSwift'
  pod 'SwiftyJSON', '~> 4.0'
  pod 'SwiftLint'
  
  # Add the Firebase pod for Google Analytics
  pod 'FirebaseAnalytics'

  # For Analytics without IDFA collection capability, use this pod instead
  # pod ‘Firebase/AnalyticsWithoutAdIdSupport’

  # Add the pods for any other Firebase products you want to use in your app
  # For example, to use Firebase Authentication and Cloud Firestore
  pod 'FirebaseAuth'
  pod 'FirebaseFirestore'

end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end

