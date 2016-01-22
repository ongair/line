version = File.read(File.expand_path('../VERSION', __FILE__)).strip

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.authors     = ['Trevor Kimenye']
  s.email       = 'Kimenye@gmail.com'
  s.homepage    = 'https://github.com/ongair/line'

  s.name        = 'line'
  s.version     = version
  s.licenses    = ['MIT']
  s.summary     = 'DSL for LINE message handling and API'
  s.description = 'API, command and message handling for LINE'

  s.files = Dir['{bin,lib}/**/*'] + %w(LICENSE Rakefile README.md README-CN.md CHANGELOG.md)
  s.executables << 'wechat'
end