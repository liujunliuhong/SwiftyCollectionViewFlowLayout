Pod::Spec.new do |spec|
  spec.name                   = 'SwiftyCollectionViewFlowLayout'
  spec.version                = '1.0.0'
  spec.homepage               = 'https://github.com/liujunliuhong/SwiftyCollectionViewFlowLayout'
  spec.source                 = { :git => 'https://github.com/liujunliuhong/SwiftyCollectionViewFlowLayout.git', :tag => spec.version }
  spec.summary                = 'A collection view layout capable of laying out views in vertically and horizontal scrolling water-flow and grids lists.'
  spec.license                = { :type => 'MIT', :file => 'LICENSE' }
  spec.author                 = { 'liujunliuhong' => 'universegalaxy96@gmail.com' }
  spec.module_name            = 'SwiftyCollectionViewFlowLayout'
  spec.swift_version          = '5.0'
  spec.platform               = :ios, '11.0'
  spec.ios.deployment_target  = '11.0'
  spec.requires_arc           = true
  spec.static_framework       = true
  spec.source_files           = 'SwiftyCollectionViewFlowLayout/Sources/*.{swift,h}'
end
