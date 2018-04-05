Pod::Spec.new do |s|
  s.name         = 'RBPrecisionTimer'
  s.version      = '1.0.0'
  s.summary      = 'A high precision timer written in Objective-C.'

  s.description  = <<-DESC
                  Intended to be used when performing time sensitive tasks. Manipulates thread execution priorities to give your code higher priority for short periods of time.
                   DESC

  s.homepage     = 'https://github.com/Raztor0/RBPrecisionTimer'

  s.license      = { :type => 'MIT' }

  s.author             = { 'Razvan Bangu' => 'raz@razb.me' }
  s.social_media_url   = 'https://twitter.com/Razvan_B'

  s.platform     = :ios

  s.source       = { :git => 'https://github.com/Raztor0/RBPrecisionTimer.git', :tag => '#{s.version}' }

  s.source_files  = 'RBPrecisionTimer/RBPrecisionTimer/*.{h,m}'

  s.requires_arc = true

end