class SessionsController < ApplicationController
  def new
    # renderöi kirjautumissivun
  end

  def create
    user = User.find_by username: params[:username]

    if user.banned
      return redirect_to :back, notice: 'Your account is frozen, please contact admin.'
    end
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      session[:username] = user.username
      redirect_to user, notice: "Welcome back!"
    else
      redirect_to :back, notice: "Username and/or password mismatch!"
    end
  end

  def destroy
    # nollataan sessio
    session[:user_id] = nil
    # uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end

  def create_oauth
    auth = env['omniauth.auth']
    user = User.find_by provider: auth.provider, id: auth.uid
    if user.nil?
      user = User.create_with_omniauth(auth)
    end
    session[:user_id] = user.id
    redirect_to user, :notice => "Signed in!"
  end
end