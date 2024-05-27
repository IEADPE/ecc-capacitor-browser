require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name = 'IeadpeCapacitorBrowser'
  s.version = package['version']
  s.summary = package['description']
  s.license = package['license']
  s.homepage = 'https://ieadpe.com.br'
  s.author = package['author']
  s.source = { :git => 'https://github.com/IeadpeSolucoes/ieadpe-capacitor-browser.git', :tag =>  'v' + package['version'] }
  s.source_files = 'ios/Sources/**/*.{swift,h,m,c,cc,mm,cpp}'
  s.ios.deployment_target  = '13.0'
  s.dependency 'Capacitor'
  s.swift_version = '5.1'
end

