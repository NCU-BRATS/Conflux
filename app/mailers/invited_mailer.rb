class InvitedMailer < ApplicationMailer

  def invite_user(email, project, inviter)
    @email = email
    @project = project
    @inviter = inviter
    mail(to: email, subject: "您已被邀請加入 #{project.name} 專案")
  end

  def join_user(user, project, inviter)
    @user = user
    @project = project
    @inviter = inviter
    mail(to: @user.email, subject: "您已被邀請加入 #{project.name} 專案")
  end

end
