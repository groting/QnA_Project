class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def facebook
    authenticate_user('facebook')
  end

  def twitter
    authenticate_user('twitter')
  end

  def new_email
    if params[:email].present?
      session['devise.email'] = params[:email]
      session['devise.need_to_confirm'] = true
      omniauth
    else
      set_flash_message(:error, :empty_email) if is_navigational_format?
      render template: 'devise/confirmations/email'
    end
  end

  private

  def authenticate_user(provider)
    session['devise.uid'] = request.env['omniauth.auth'][:uid]
    session['devise.provider'] = request.env['omniauth.auth'][:provider]
    session['devise.email'] = request.env['omniauth.auth'][:info][:email]
    if session['devise.email'].blank?
      render 'devise/confirmations/email'
    else
      omniauth
    end
  end

  def omniauth
    @user = User.find_for_oauth(session)
    if @user&.persisted? && @user&.confirmed?
      set_flash_message(:notice, :success, kind: session['devise.provider']) if is_navigational_format?
      sign_in_and_redirect @user, event: :authentication
    else
      set_flash_message(:notice, :failure, kind: session['devise.provider'],
        reason: 'you need to confirm email') if is_navigational_format?
      redirect_to root_path
    end
  end
end