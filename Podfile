# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def presentation_pods
  pod 'Anchorage'
  pod 'Kingfisher', '~> 5.0'
  pod 'TagListView', '~> 1.0'
end

def data_pods
  pod 'Moya', '~> 14.0'
end

def tests_pods

end

target 'Gist' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  presentation_pods
  data_pods

  target 'GistTests' do
    inherit! :search_paths

    tests_pods
  end

  target 'GistUITests' do
    tests_pods
  end

end
