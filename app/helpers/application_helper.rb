module ApplicationHelper
    def nav_links
      rooms = Room.all
      rooms.each do |room|
        concat(render partial: "layouts/nav_item", locals: { page_name: room.name, page_path: board_today_path(room.name), color: "dark" })
      end
      concat(render partial: "layouts/nav_item", locals: { page_name: t("my_reservation"), page_path: my_reservation_path, color: "dark" })
      concat(render partial: "layouts/nav_item", locals: { page_name: t("room"), page_path: rooms_path, color: "dark" })
      if current_user&.admin?
        concat(render partial: "layouts/nav_item", locals: { page_name: t("reservation"), page_path: reservations_path, color: "danger" })
        concat(render partial: "layouts/nav_item", locals: { page_name: t("user"), page_path: users_path, color: "danger" })
        concat(render partial: "layouts/nav_item", locals: { page_name: t("time_slot"), page_path: time_slots_path, color: "danger" })
      end
    end

    def nav_link(page_name, page_path, color)
      if request.env["REQUEST_URI"].start_with?(page_path)
        link_to(page_name, page_path, class: "nav-link link-light bg-#{color} px-3 py-3")
      else
        link_to(page_name, page_path, class: "nav-link link-#{color} bg-light px-3 py-3")
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
