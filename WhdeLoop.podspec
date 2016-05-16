Pod::Spec.new do |s|
s.name          = "WhdeLoop"
s.version       = "1.0.0"
s.summary       = "iOS Banner."
s.homepage      = "https://github.com/whde/Loop"
s.license       = 'MIT'
s.author        = { "Whde" => "460290973@qq.com" }
s.platform      = :ios, "7.0"
s.source        = { :git => "https://github.com/whde/Loop.git", :tag => s.version.to_s }
s.source_files  = 'WhdeLoop/Class/*{h,m}'
s.frameworks    = 'Foundation', 'CoreGraphics', 'UIKit'
s.requires_arc  = true
s.description   = <<-DESC
iOS Banner 无限滚动
DESC
end
