# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'TMDbApp' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!
    
    # Pods for TMDbApp
    pod 'SwiftLint'
    pod 'RxSwift',   '~> 4.0'
    pod 'RxCocoa',   '~> 4.0'
    pod 'Kingfisher', '~> 4.0'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'RxSwift' || target.name == 'RxCocoa'
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.0'
            end
        end
    end
end
