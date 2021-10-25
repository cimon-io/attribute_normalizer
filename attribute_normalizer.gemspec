# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require "attribute_normalizer/version"

Gem::Specification.new do |s|

  s.name         = 'attribute_normalizer'
  s.version      = AttributeNormalizer::Version

  s.authors      = [ 'Michael Deering', 'Alexey Osipenko' ]
  s.email        = [ 'mdeering@mdeering.com', 'alexey@cimon.io' ]
  s.homepage     = 'https://github.com/mdeering/attribute_normalizer'

  s.license      = 'MIT'
  s.summary      = 'Configurable data normalization'
  s.description  = 'Configurable attribute data normalization'

  s.require_path = 'lib'

  s.files        = Dir["{lib}/**/*"] + [ 'README.textile' ]

  s.add_dependency 'postrank-uri' # needs for UrlNormalizer
end
