class AgendasController < ApplicationController
  before_action :set_agenda, only: %i[show edit update destroy]

  def index
    @agendas = Agenda.all
  end

  def new
    @team = Team.friendly.find(params[:team_id])
    @agenda = Agenda.new
  end

  def create
    @agenda = current_user.agendas.build(title: params[:title])
    @agenda.team = Team.friendly.find(params[:team_id])
    current_user.keep_team_id = @agenda.team.id
    if current_user.save && @agenda.save
      redirect_to dashboard_url, notice: I18n.t('views.messages.create_agenda') 
    else
      render :new
    end
  end

  # add destroy action
  def destroy
    return redirect_to dashboard_url, notice: 'Leader or maker can delete agenda' if current_user != @agenda.user && current_user != @agenda.team.owner

    # send mailer to the team members
    @agenda.team.members.each do |member|
      AgendaDeleteMailer.agenda_delete_mail(member, @agenda).deliver
    end
    @agenda.destroy
    redirect_to dashboard_url, notice: 'destoryed agenda'
  end

  private

  def set_agenda
    @agenda = Agenda.find(params[:id])
  end

  def agenda_params
    params.fetch(:agenda, {}).permit %i[title description]
  end
end
