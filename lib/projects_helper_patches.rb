require_dependency 'projects_helper'

module ProjectsHelper
  module Patches
    module ProjectsHelperPatch
      def self.included(base) # :nodoc:
        base.send(:include, InstanceMethods)

	base.class_eval do
          unloadable
          alias_method_chain :render_project_action_links, :copy
        end
      end

      module InstanceMethods
        def render_project_action_links_with_copy
	  project_source = Project.find_by_id(Setting.plugin_project_from_copy['default_project_id']) unless Setting.plugin_project_from_copy['default_project_id'].blank?
          links = render_project_action_links_without_copy.split(" | ")
	  if User.current.allowed_to?(:add_project, nil, :global => true) && ! project_source.nil?
            links.insert 1, link_to(l(:label_project_new_from_copy, :project => project_source.name), { :controller => 'projects', :action => 'copy', :id => project_source.id }, :class => 'icon icon-copy')
	  end
          links.join(" | ").html_safe
        end
      end
    end
  end
end

unless ProjectsHelper.included_modules.include? ProjectsHelper::Patches::ProjectsHelperPatch
  ProjectsHelper.send(:include, ProjectsHelper::Patches::ProjectsHelperPatch)
end
