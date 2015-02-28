Pod::Spec.new do |s|
  s.name             = "Gizou"
  s.version          = "0.1.4"
  s.summary          = "A library for creating test data."
  s.homepage         = "https://github.com/smyrgl/Gizou"
  s.license          = 'MIT'
  s.author           = { "John Tumminaro" => "john@tinylittlegears.com" }
  s.source           = { :git => "https://github.com/smyrgl/Gizou.git", :tag => s.version.to_s }

  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.7'
  s.requires_arc = true

  s.source_files = 'Gizou/*.{h,m}'
  s.resources = 'Gizou/Assets/*.json'
  s.private_header_files = 'Gizou/Private/*.h'

  s.ios.exclude_files = 'Gizou/osx'
  s.osx.exclude_files = 'Gizou/ios'
  s.frameworks = 'Foundation'

  s.subspec 'Private' do |ss|
    ss.source_files = 'Gizou/Private/*.{h,m}'
  end

  s.subspec 'ios' do |ss|
    ss.ios.deployment_target = '6.0'

    ss.ios.source_files = 'Gizou/ios/*.{h,m}'
    ss.osx.source_files = ''
  end

  s.subspec 'osx' do |ss|
    s.osx.deployment_target = '10.7'

    ss.ios.source_files = ''
    ss.osx.source_files = 'Gizou/osx/*.{h,m}'
  end
end
