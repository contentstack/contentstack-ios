Pod::Spec.new do |s|
s.name             = 'Contentstack'
s.version          = '3.1.0'
s.summary          = 'Built.io Contentstack is a headless CMS with an API-first approach that puts content at the centre.'

s.description      = <<-DESC
Built.io Contentstack is a headless CMS with an API-first approach that puts content at the centre. It is designed to simplify the process of publication by separating code from content. 
In a world where content is consumed via countless channels and form factors across mobile, web and IoT, Built.io Contentstack reimagines content management by decoupling code from content. Business users manage content – no training or development required. Developers can create cross-platform apps and take advantage of a headless CMS that delivers content through APIs. With an architecture that’s extensible – but without the bloat of legacy CMS – Built.io Contentstack cuts down on infrastructure, maintenance, cost and complexity.
DESC

s.homepage         = 'https://www.built.io/products/contentstack/overview'
s.license          = { :type => 'Commercial',:text => 'See https://www.built.io/'}
s.author           = { 'Built.io' => 'support@contentstack.io' }
s.source           = { :git => 'https://github.com/builtio-contentstack/contentstack-ios.git', :tag => '3.1.0' }
s.social_media_url = 'https://twitter.com/builtio'

s.ios.deployment_target = '7.0'

s.source_files = 'ThirdPartyExtension/AFNetworking/*.{h,m}','ThirdPartyExtension/ISO8601DateFormatter/*.{h,m}','ThirdPartyExtension/MMarkDown/*.{h,m}', 'ContentStackIO/*.{h,m}', 'ContentStackIO/ThirdPartyNamespaceHeader/*.h', 'ContentStackIO_Internal/*.{h,m}'
s.public_header_files = 'ContentStackIO/*.h','ContentStackIO/ThirdPartyNamespaceHeader/*.h'

s.frameworks =  'CoreGraphics', 'MobileCoreServices', 'Security', 'SystemConfiguration'
s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }

end
