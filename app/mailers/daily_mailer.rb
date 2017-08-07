class DailyMailer < ApplicationMailer
  def digest(user)
    @questions = Questions.lastday
    mail to: user.email, subject: "The last day questions digest!"
  end
end
