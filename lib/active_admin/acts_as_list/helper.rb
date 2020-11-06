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
      def sortable_column
        column '' do |resource|
          actions = ActiveSupport::SafeBuffer.new

          actions << link_to("&#8648;&nbsp;".html_safe, "#{resource_path(resource)}/move_to_top", style: 'font-size: 20pt; text-decoration: none;') unless resource.first?
          actions << link_to("&#8639;&nbsp;".html_safe, "#{resource_path(resource)}/move_up", style: 'font-size: 20pt; text-decoration: none;') unless resource.first?
          actions << link_to("&#8643;&nbsp;".html_safe, "#{resource_path(resource)}/move_down", style: 'font-size: 20pt; text-decoration: none;') unless resource.last?
          actions << link_to("&#8650;&nbsp;".html_safe, "#{resource_path(resource)}/move_to_bottom", style: 'font-size: 20pt; text-decoration: none;') unless resource.last?

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
            redirect_to :back, :notice => I18n.t('acts_as_list.illegal_move_to_top', :resource => resource_class.to_s.camelize.constantize.model_name.human )
          else
            resource.move_to_top
            redirect_to :back, :notice => I18n.t('acts_as_list.moved_to_top', :resource => resource_class.to_s.camelize.constantize.model_name.human )
          end
        end

        member_action :move_to_bottom do
          if resource.last?
            redirect_to :back, :notice => I18n.t('acts_as_list.illegal_move_to_bottom', :resource => resource_class.to_s.camelize.constantize.model_name.human )
          else
            resource.move_to_bottom
            redirect_to :back, :notice => I18n.t('acts_as_list.moved_to_bottom', :resource => resource_class.to_s.camelize.constantize.model_name.human )
          end
        end

        member_action :move_up do
          if resource.first?
            redirect_to :back, :notice => I18n.t('acts_as_list.illegal_move_up', :resource => resource_class.to_s.camelize.constantize.model_name.human )
          else
            resource.move_higher
            redirect_to :back, :notice => I18n.t('acts_as_list.moved_up', :resource => resource_class.to_s.camelize.constantize.model_name.human )
          end
        end

        member_action :move_down do
          if resource.last?
            redirect_to :back, :notice => I18n.t('acts_as_list.illegal_move_down', :resource => resource_class.to_s.camelize.constantize.model_name.human )
          else
            resource.move_lower
            redirect_to :back, :notice => I18n.t('acts_as_list.moved_down', :resource => resource_class.to_s.camelize.constantize.model_name.human )
          end
        end
      end
    end
  end
end
