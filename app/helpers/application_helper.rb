module ApplicationHelper
    def nav_links
        if current_user&.admin?
            concat(render partial: "layouts/nav_item", locals: { page_name: t("time_slot"), page_path: time_slots_path, color: "danger" })
            concat(render partial: "layouts/nav_item", locals: { page_name: t("user"), page_path: users_path, color: "danger" })
        # TODO reservations
        else
          # TODO reservations
        end
    end

    def nav_link(page_name, page_path, color)
        if request.env["REQUEST_URI"].start_with?(page_path)
          link_to(page_name, page_path, class: "nav-link link-light bg-#{color}")
        else
          link_to(page_name, page_path, class: "nav-link link-#{color} bg-light")
        end
    end

    def user_dropdown
      if logged_in?
        render "layouts/logged_in_dropdown"
      else
        render "layouts/logged_out_dropdown"
      end
    end
end
