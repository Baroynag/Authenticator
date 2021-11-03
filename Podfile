platform :ios, '10.0'
use_frameworks!

target 'Authenticator' do

  pod 'OneTimePassword', '~> 3.2'

  pod 'RNCryptor', '~> 5.0'

  pod 'SwiftProtobuf', '~> 1.0'

end


target 'SOTPWatch' do
  platform :watchos, '5.0'
  pod 'OneTimePassword'

  target 'SOTPWatch Extension' do
    platform :watchos, '5.0'
    inherit! :search_paths
    pod 'OneTimePassword'
  end
end
