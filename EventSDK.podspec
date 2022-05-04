
Pod::Spec.new do |s|
  s.name = 'EventSDK'
  s.version = '0.0.1'
  s.license = 'MIT'
  s.summary = 'EventSDK framework'
  s.homepage = 'https://github.com/miromax21/miromaxPod'
  s.authors = { 'miromax21' => 'miromax21@gmail.com' }
  
  s.source = { :git => 'https://github.com/miromax21/miromaxPod.git', :tag => s.version.to_s }
  s.source_files = 'Sources/*.swift'
  s.swift_version = '5.0'
  s.platform = :ios, '13.0'

end