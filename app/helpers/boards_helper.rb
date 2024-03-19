module BoardsHelper
    def reservation_info(day, time_slot)
        reservation = day[time_slot]
        if reservation.nil?
            link_to(
                t(".book_button_text"),
                reservations_path(
                  room_id: @room.id,
                  time_slot_id: time_slot.id,
                  date: day["date"].to_s
                ),
                method: :post,
                data: {
                  turbo_method: :post
                },
                class: "btn btn-light rounded-0 w-100"
            )
        elsif reservation.user == current_user
            link_to(
                t(".cancel_button_text"),
                reservation,
                method: :delete,
                data: {
                  turbo_method: :delete
                },
                class: "btn btn-dark rounded-0 w-100"
            )
        else
            content_tag(:div, reservation.user.nickname, class: [ "w-100", "text-center py-2 text-primary" ])
        end
    end
end
