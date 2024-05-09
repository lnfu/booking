class UserMailer < ApplicationMailer

    default from: '交大鋼琴社琴房預約系統 <' + ENV.fetch("GMAIL_SENDER") + '>'
    
    def forgot_password_email(user)
        @user = user
        mail(
            to:@user.email,
            subject:"重設密碼連結",
        )
    end
end