Pod::Spec.new do |spec|
  spec.name = 'BFColorPickerPopover'
  spec.version = '0.1.0'
  spec.authors = {'Balázs Faludi' => 'balazsfaludi@gmail.com'}
  spec.homepage = 'https://github.com/DrummerB/BFColorPickerPopover'
  spec.summary = 'The standard OS X color picker put into an NSPopover.'
  spec.source = {:git => 'https://github.com/DrummerB/BFColorPickerPopover.git', :commit => 'e171d6b127e21210802fa0edfd67663e906ad2a9'}
  spec.license = { :type => 'BSD', :file => 'License' }

  spec.platform = :osx
  spec.requires_arc = true
  spec.source_files = 'BFColorPickerPopover/**/*.{h,m}'
end
