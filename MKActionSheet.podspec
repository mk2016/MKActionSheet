Pod::Spec.new do |s|
  s.name              = "MKActionSheet"
  s.version           = "2.0.1"
  s.summary           = "multi styles and multifunctional actionSheet"
  s.homepage          = "https://github.com/mk2016/MKActionSheet"
  s.license           = "MIT"
  s.author            = { "MK Xiao" => "xiaomk7758@sina.com" }
  s.social_media_url  = "https://mk2016.github.io"
  s.platform          = :ios, "8.0"
  s.source            = { :git => "https://github.com/mk2016/MKActionSheet.git", :tag => s.version }
  s.source_files      = "MKActionSheet/**/*.{h,m}"
  s.resource          = "MKActionSheet/MKActionSheet.bundle"
  s.requires_arc      = true
  s.dependency        "Masonry", '~> 1.0.2'
  s.dependency        "SDWebImage", '~> 4.0.0'

end
