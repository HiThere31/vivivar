class NotificationSettingsController < ApplicationController
  def update
    Current.user.update(params.expect(user: %i[notify_uploads notify_reveals notify_reminder]))
    redirect_to us_path
  end
end
