Pod::Spec.new do |s|
  s.name      = 'FormatterKit'
  s.version   = '1.5.1-aut'
  s.license   = { :type => 'MIT' }
  s.summary   = '`stringWithFormat:` for the sophisticated hacker set.'
  s.homepage  = 'https://github.com/mattt/FormatterKit'
  s.social_media_url = 'https://twitter.com/mattt'
  s.author    = { 'Mattt Thompson' => 'm@mattt.me' }
  s.source    = { :git => 'https://github.com/Automatic/FormatterKit.git', :tag => '1.5.1-aut' }

  s.description = "FormatterKit is a collection of well-crafted NSFormatter subclasses for things like units of information, distance, and relative time intervals. Each formatter abstracts away the complex business logic of their respective domain, so that you can focus on the more important aspects of your application."

  s.requires_arc = true

  s.resource_bundles = { 'FormatterKit' => ['Localizations/**'] }

  s.subspec 'AddressFormatter' do |ss|
    ss.source_files = ['FormatterKit/TTTAddressFormatter.{h,m}', 'FormatterKit/FormatterKit.h']
    ss.osx.frameworks = 'AddressBook'
    ss.ios.frameworks = 'AddressBook', 'AddressBookUI'
  end

  s.subspec 'ArrayFormatter' do |ss|
    ss.source_files = ['FormatterKit/TTTArrayFormatter.{h,m}', 'FormatterKit/FormatterKit.h']
  end

  s.subspec 'ColorFormatter' do |ss|
    ss.source_files = ['FormatterKit/TTTColorFormatter.{h,m}', 'FormatterKit/FormatterKit.h']
  end

  s.subspec 'LocationFormatter' do |ss|
    ss.source_files = ['FormatterKit/TTTLocationFormatter.{h,m}', 'FormatterKit/FormatterKit.h']
    ss.frameworks = 'CoreLocation'
  end

  s.subspec 'OrdinalNumberFormatter' do |ss|
    ss.source_files = ['FormatterKit/TTTOrdinalNumberFormatter.{h,m}', 'FormatterKit/FormatterKit.h']
  end

  s.subspec 'TimeIntervalFormatter' do |ss|
    ss.source_files = ['FormatterKit/TTTTimeIntervalFormatter.{h,m}', 'FormatterKit/FormatterKit.h']
  end

  s.subspec 'UnitOfInformationFormatter' do |ss|
    ss.source_files = ['FormatterKit/TTTUnitOfInformationFormatter.{h,m}', 'FormatterKit/FormatterKit.h']
  end

  s.subspec 'URLRequestFormatter' do |ss|
    ss.source_files = ['FormatterKit/TTTURLRequestFormatter.{h,m}', 'FormatterKit/FormatterKit.h']
  end
end
