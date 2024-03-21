Pod::Spec.new do |s|
s.name             = 'Contentstack'
s.version          = '3.12.2'
s.summary          = 'Contentstack is a headless CMS with an API-first approach that puts content at the centre.'

s.description      = <<-DESC
Contentstack is a headless CMS with an API-first approach that puts content at the centre. It is designed to simplify the process of publication by separating code from content. 
In a world where content is consumed via countless channels and form factors across mobile, web and IoT. Contentstack reimagines content management by decoupling code from content. Business users manage content – no training or development required. Developers can create cross-platform apps and take advantage of a headless CMS that delivers content through APIs. With an architecture that’s extensible – but without the bloat of legacy CMS – Contentstack cuts down on infrastructure, maintenance, cost and complexity.
DESC

s.homepage         = 'https://www.contentstack.com/'
s.license          = { :type => 'Commercial',:text => 'See https://www.contentstack.com/'}
s.author           = { 'Contentstack' => 'support@contentstack.io' }

s.source           = { :git => 'https://github.com/contentstack/contentstack-ios.git', :tag => 'v3.12.2' }
s.social_media_url = 'https://twitter.com/Contentstack'

s.ios.deployment_target = '11.0'


s.source_files = 'ThirdPartyExtension/ISO8601DateFormatter/*.{h,m}','ThirdPartyExtension/Networking/*.{h,m}','ThirdPartyExtension/MMarkDown/*.{h,m}', 'Contentstack/*.{h,m}', 'Contentstack/ThirdPartyNamespaceHeader/*.h', 'ContentstackInternal/*.{h,m}'
s.public_header_files = 'Contentstack/*.h','Contentstack/ThirdPartyNamespaceHeader/*.h'

s.frameworks =  'CoreGraphics', 'MobileCoreServices', 'Security', 'SystemConfiguration'
s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }

end
