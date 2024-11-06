# Uncomment the next line to define a global platform for your project
  platform :ios, '13'

target 'BeautySync' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for BeautySync

pod 'DropDown'
pod 'Stripe'
pod 'StripePaymentSheet'
pod 'DGCharts'
pod 'youtube-ios-player-helper'
pod 'MaterialComponents/Buttons'
pod 'MaterialComponents/Buttons+Theming'
pod 'MaterialComponents/TextControls+FilledTextAreas'
pod 'MaterialComponents/TextControls+FilledTextFields'
pod 'MaterialComponents/TextControls+OutlinedTextAreas'
pod 'MaterialComponents/TextControls+OutlinedTextFields'
pod 'MaterialComponents/TextControls+FilledTextAreasTheming'
pod 'MaterialComponents/TextControls+FilledTextFieldsTheming'
pod 'MaterialComponents/TextControls+OutlinedTextAreasTheming'
pod 'MaterialComponents/TextControls+OutlinedTextFieldsTheming'


post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13'
            end
        end
    end
end

end
