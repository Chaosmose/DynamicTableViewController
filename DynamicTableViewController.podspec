Pod::Spec.new do |s|
  s.name        = 'DynamicTableViewController'
  s.version     = '1.1'
  s.authors     = { 'Benoit Pereira da Silva' => 'benoit@pereira-da-silva.com' }
  s.homepage    = 'https://github.com/benoit-pereira-da-silva/DynamicTableViewController'
  s.summary     = 'Table View cell configuration + automatic cells heights computation based on autolayout'
  s.source      = { :git => 'https://github.com/benoit-pereira-da-silva/DynamicTableViewController.git'}
  s.license     = { :type => "MIT" }
  s.ios.deployment_target = '7.0'
  s.requires_arc = true
  s.frameworks   = 'UIKit'
  s.source_files =  'Classes/*.{h,m}'
  s.public_header_files = 'Classes/*.h'
  s.social_media_url = 'https://twitter.com/bpereiradasilva'
end
