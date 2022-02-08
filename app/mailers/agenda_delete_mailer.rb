class AgendaDeleteMailer < ApplicationMailer
  default from: 'from@example.com'

  def agenda_delete_mail(user, agenda)
    @email = user.email
    @agenda = agenda
    mail to: @email, subject: "Agenda: #{@agenda.title} has been deleted"
  end
end
