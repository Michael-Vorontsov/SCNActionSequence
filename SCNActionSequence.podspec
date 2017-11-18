Pod::Spec.new do |s|
  s.name             = 'SCNActionSequence'
  s.version          = '1.0.0'
  s.summary          = 'Allow to create simple sequences for scene kit animation.'

  s.description      = <<-DESC
There is alway a problem to build chain of animations in SceneKit or ARKit.
Native mechanisms allows to chain several animation and run them on one node, but can't help to chain animations of different nodes.
SCNActionSequence to fit that gap.
                       DESC

  s.homepage         = 'https://github.com/Michael-Vorontsov/SCNActionSequence'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Michael-Vorontsov' => 'michel06@ukr.net' }
  s.source           = { :git => 'https://github.com/Michael-Vorontsov/SCNActionSequence.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'SCNActionSequence/Classes/**/*'

end

