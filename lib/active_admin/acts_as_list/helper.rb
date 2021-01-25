module ActiveAdmin
  module ActsAsList
    module Helper
      # Call this inside your index do...end bock to make your resource sortable.
      #
      # Example:
      #
      # # app/admin/players.rb
      #
      #  ActiveAdmin.register Player do
      #    index do
      #      # This adds columns for moving up, down, top and bottom.
      #      sortable_column
      #      #...
      #      column :firstname
      #      column :lastname
      #      default_actions
      #    end
      #  end
      # @param [Proc] base_path if given will override resource path (useful for nested resources)s
      def sortable_column(base_path: nil)
        column '' do |resource|
          actions = ActiveSupport::SafeBuffer.new
          sortable_path = base_path.present? ? base_path.call(resource) : resource_path(resource)

          unless resource.first?
            actions << link_to("&#8648;".html_safe, "#{sortable_path}/move_to_top", style: 'font-size: 20pt; text-decoration: none;')
            actions << text_node(' ')
          end
          unless resource.first?
            actions << link_to("&#8639;".html_safe, "#{sortable_path}/move_up", style: 'font-size: 20pt; text-decoration: none;')
            actions << text_node(' ')
          end
          unless resource.last?
            actions << link_to("&#8643;".html_safe, "#{sortable_path}/move_down", style: 'font-size: 20pt; text-decoration: none;')
            actions << text_node(' ')
          end
          unless resource.last?
            actions << link_to("&#8650;".html_safe, "#{sortable_path}/move_to_bottom", style: 'font-size: 20pt; text-decoration: none;')
            actions << text_node(' ')
          end

          actions
        end
      end

      # Call this inside your resource definition to add the needed member actions
      # for your sortable resource.
      #
      # Example:
      #
      # # app/admin/players.rb
      #
      #  ActiveAdmin.register Player do
      #    # Sort players by position
      #    config.sort_order = 'position'
      #
      #    # Add member actions for positioning.
      #    sortable_member_actions
      #  end
      def sortable_member_actions
        member_action :move_to_top do
          if resource.first?
            redirect_notice = I18n.t('acts_as_list.illegal_move_to_top', resource: resource_class.to_s.camelize.constantize.model_name.human)
          else
            resource.move_to_top
            redirect_notice = I18n.t('acts_as_list.moved_to_top', resource: resource_class.to_s.camelize.constantize.model_name.human)
          end

          if Rails::VERSION::MAJOR >= 5
            redirect_back fallback_location: resource_path, notice: redirect_notice
          else
            redirect_to :back, notice: redirect_notice
          end
        end

        member_action :move_to_bottom do
          if resource.last?
            redirect_notice = I18n.t('acts_as_list.illegal_move_to_bottom', resource: resource_class.to_s.camelize.constantize.model_name.human)
          else
            resource.move_to_bottom
            redirect_notice = I18n.t('acts_as_list.moved_to_bottom', resource: resource_class.to_s.camelize.constantize.model_name.human)
          end

          if Rails::VERSION::MAJOR >= 5
            redirect_back fallback_location: resource_path, notice: redirect_notice
          else
            redirect_to :back, notice: redirect_notice
          end
        end

        member_action :move_up do
          if resource.first?
            redirect_notice = I18n.t('acts_as_list.illegal_move_up', resource: resource_class.to_s.camelize.constantize.model_name.human)
          else
            resource.move_higher
            redirect_notice = I18n.t('acts_as_list.moved_up', resource: resource_class.to_s.camelize.constantize.model_name.human)
          end

          if Rails::VERSION::MAJOR >= 5
            redirect_back fallback_location: resource_path, notice: redirect_notice
          else
            redirect_to :back, notice: redirect_notice
          end
        end

        member_action :move_down do
          if resource.last?
            redirect_notice = I18n.t('acts_as_list.illegal_move_down', resource: resource_class.to_s.camelize.constantize.model_name.human)
          else
            resource.move_lower
            redirect_notice = I18n.t('acts_as_list.moved_down', resource: resource_class.to_s.camelize.constantize.model_name.human)
          end

          if Rails::VERSION::MAJOR >= 5
            redirect_back fallback_location: resource_path, notice: redirect_notice
          else
            redirect_to :back, notice: redirect_notice
          end
        end
      end
    end
  end
end
