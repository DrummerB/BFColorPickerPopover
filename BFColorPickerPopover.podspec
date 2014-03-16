Pod::Spec.new do |spec|
  spec.name = 'BFColorPickerPopover'
  spec.version = '1.0.0'
  spec.authors = {'Balázs Faludi' => 'balazsfaludi@gmail.com'}
  spec.homepage = 'https://github.com/DrummerB/BFColorPickerPopover'
  spec.summary = 'The standard OS X color picker put into an NSPopover.'
  spec.source = {:git => 'https://github.com/DrummerB/BFColorPickerPopover.git', :tag => spec.version.to_s}
  spec.license = { :type => 'BSD', :file => 'License' }

  spec.platform = :osx
  spec.requires_arc = true
  spec.source_files = 'BFColorPickerPopover/**/*.{h,m}'
end
