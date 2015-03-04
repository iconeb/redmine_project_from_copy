Redmine::Plugin.register :project_from_copy do
  name 'Project From Copy plugin'
  author 'Federico Nebiolo'
  description 'This is a quick plugin to allow users to copy from selected project'
  version '0.0.2'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  settings :default => {'default_project_id' => nil},
           :partial => 'settings/default_project'
end

require 'dispatcher' unless Rails::VERSION::MAJOR >= 3

if Rails::VERSION::MAJOR >= 3
  ActionDispatch::Callbacks.to_prepare do
    require_dependency 'projects_helper_patches'
  end
else
  Dispatcher.to_prepare BW_AssetHelpers::PLUGIN_NAME do
    require_dependency 'projects_helper_patches'
  end
end
