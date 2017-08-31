
Pod::Spec.new do |s|
  s.name     = 'JWAnimationView'
  s.version  = '0.0.2'
  s.license  = 'MIT'
  s.summary  = 'the animation for angle'
  s.homepage = 'https://github.com/upworldcjw'
  s.author   = { 'upowrld' => '1042294579@qq.com' }
  s.source   = { :git => 'https://github.com/upworldcjw/JWAnimationView.git', :tag => '0.0.2' }
  s.source_files = 'JWAnimationView/*.{h,m,mm}'
  s.ios.frameworks = 'Foundation', 'UIKit'
  s.ios.deployment_target = '6.0' 
  s.requires_arc = true
end
