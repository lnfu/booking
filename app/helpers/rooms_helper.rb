module RoomsHelper
    def room_row(room)
        if current_user.regular?
            render partial: "regular_row", locals: { room: room }
        elsif current_user.admin?
            render partial: "admin_row", locals: { room: room }
        end
    end
    def room_head
        if current_user.regular?
            render partial: "regular_head"
        elsif current_user.admin?
            render partial: "admin_head"
        end
    end
end
