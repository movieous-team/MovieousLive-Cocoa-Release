Pod::Spec.new do |spec|
  spec.ios.deployment_target = '8.0'
  spec.name         = 'MovieousLive'
  spec.version      = `sh utils.sh get-version`
  spec.homepage     = 'https://github.com/movieous-team/MovieousLive-Cocoa-Release'
  spec.authors      = { 'movieous' => 'cloudop@movieous.video' }
  spec.summary      = 'Movieous live broadcaster for iOS.'
  spec.source       = { :git => 'https://github.com/movieous-team/MovieousLive-Cocoa-Release.git', :tag => "v#{spec.version}" }
  spec.static_framework = true
  spec.vendored_frameworks = 'MovieousLive.framework'
  spec.libraries    = 'c++', 'resolv'
  spec.dependency 'MovieousBase', '~> 1.0.8'
end