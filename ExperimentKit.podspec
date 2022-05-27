Pod::Spec.new do |spec|
  spec.name = "ExperimentKit"
  spec.version = "0.0.1"
  spec.summary = "ExperimentKit"
  spec.description = "ExperimentKit"
  spec.homepage = "homepage"

  spec.license = { :type => "MIT", :file => "FILE_LICENSE" }

  spec.author = { "Kamil Khairullin" => "k.khayrullin@innopolis.university" }
  spec.source = { :git => "local", :tag => "#{spec.version}" }

  spec.prefix_header_file = false
  spec.ios.deployment_target = '11.0'

  spec.source_files = [
    'ExperimentKit/**/*.{swift,h,m}'
  ]

  spec.dependency 'Firebase/Core'
  spec.dependency 'Firebase/RemoteConfig'
  
  spec.xcconfig = {
    'HEADER_SEARCH_PATHS' => [
      '"${PODS_ROOT}/Headers/Public/Firebase"'
    ]
  }
end
