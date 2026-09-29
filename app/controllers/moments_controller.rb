class MomentsController < ApplicationController
  before_action :set_day, only: %i[new create]

  def new
    return redirect_to(root_path) if @day.moment_for(Current.user)

    @moment = @day.moments.new
  end

  def create
    @moment = @day.moments.new(moment_params.merge(user: Current.user))

    if @moment.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Respuesta de una línea a la foto del otro (se guarda en mi propio momento)
  def update
    moment = Current.user.moments.find(params[:id])
    moment.update(reply: params.expect(moment: [:reply])[:reply].to_s.strip.first(80))
    redirect_back_or_to root_path
  end

  private
    def set_day
      @day = Day.today
    end

    def moment_params
      params.expect(moment: %i[photo caption])
    end
end
