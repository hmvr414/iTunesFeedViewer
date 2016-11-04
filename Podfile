# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'


  # Pods for RappiChallenge
target 'RappiChallenge' do
    inherit! :search_paths
    use_frameworks!
    # Pods for testing
    pod 'Realm', git: 'https://github.com/realm/realm-cocoa.git', branch: 'master', submodules: true
    pod 'RealmSwift', git: 'https://github.com/realm/realm-cocoa.git', branch: 'master', submodules: true
    pod 'Alamofire', '~> 4.0'
    pod 'SwiftyJSON', '3.0.0'
    pod 'SDWebImage', '~>3.8'
    pod 'ReachabilitySwift', '~> 3'
    pod 'ObjectMapper', '~> 2.2'
    pod 'ObjectMapper+Realm'
    pod 'AlamofireObjectMapper', '~> 4.0'
end


  target 'RappiChallengeTests' do
    inherit! :search_paths
    use_frameworks!
    # Pods for testing
    	pod 'Realm', git: 'https://github.com/realm/realm-cocoa.git', branch: 'master', submodules: true
	pod 'RealmSwift', git: 'https://github.com/realm/realm-cocoa.git', branch: 'master', submodules: true
    pod 'Alamofire', '~> 4.0'
    pod 'SwiftyJSON', '3.0.0'
    pod 'SDWebImage', '~>3.8'
    pod 'ReachabilitySwift', '~> 3'
    pod 'ObjectMapper', '~> 2.2'
    pod 'ObjectMapper+Realm'
    pod 'AlamofireObjectMapper', '~> 4.0'
  end

  target 'RappiChallengeUITests' do
    inherit! :search_paths
    use_frameworks!
    # Pods for testing
    	pod 'Realm', git: 'https://github.com/realm/realm-cocoa.git', branch: 'master', submodules: true
	pod 'RealmSwift', git: 'https://github.com/realm/realm-cocoa.git', branch: 'master', submodules: true
    pod 'Alamofire', '~> 4.0'
    pod 'SwiftyJSON', '3.0.0'
    pod 'SDWebImage', '~>3.8'
    pod 'ReachabilitySwift', '~> 3'
    pod 'ObjectMapper', '~> 2.2'
    pod 'ObjectMapper+Realm'
    pod 'AlamofireObjectMapper', '~> 4.0'
  end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0' # or '3.0'
    end
  end
end
