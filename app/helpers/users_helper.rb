module UsersHelper
    def user_verification_button(user)
        if user.guest?
            link_to(
                t(".verify"),
                upgrade_guest_to_regular_user_path(user.id),
                method: :patch,
                data: { turbo_method: :patch, turbo_confirm: "Sure?" },
                class: "btn btn-primary"
            )
        else
            t(".verified")
        end
    end

  # def set_admin_button(user, current_user)
  #     unless current_user&.id == user.id
  #         if user.admin?
  #             t(".admin")
  #         elsif user.guest?
  #             "非社員無法成為管理員"
  #         else
  #             link_to t(".set_admin"), promote_to_admin_user_path(user.id), data: { turbo_method: :patch }, class: "btn btn-primary w-100"
  #         end
  #     end
  # end
end
