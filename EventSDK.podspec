
Pod::Spec.new do |s|
  s.name = 'EventSDK'
  s.version = '0.4.0'
  s.license = 'MIT'
  s.summary = 'EventSDK framework'
  s.homepage = 'https://github.com/miromax21/miromaxPod'
  s.authors = { 'miromax21' => 'miromax21@gmail.com' }
  
  s.source = { :git => 'https://github.com/miromax21/miromaxPod.git', :tag => s.version.to_s }
  s.source_files = 'Sources/*.swift', 'Sources/extentions/*.swift', 'Sources/models/*.swift', 'Sources/NS/*.swift'
  s.swift_version = '4.0'
  s.platform = :ios, '12.0'

end