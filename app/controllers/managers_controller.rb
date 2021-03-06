class ManagersController < ApplicationController

  authorize_resource

  # GET /managers
  def index
    cur_acc = current_account
    if cur_acc.is_manager?
      render json: cur_acc.manager
    else
      render json: { errors: "You don't have permission" }, status: 403
    end
  end

  # GET /managers/1
  def show
    manager = Manager.find(params[:id])
    if can? :read, manager
      render json: manager
    else
      render json: { errors: "You can't access this manager" }, status: 403
    end
  end

  # POST /managers
  def create
    manager = Manager.create(manager_params)

    if manager.persisted?
      render json: manager, status: 201
    else
      render json: { errors: manager.errors.full_messages }.to_json, status: 422
    end
  end

  # PATCH/PUT /managers/1
  def update
    manager = Manager.find(params[:id])

    if can? :update, manager
      account = manager.account
      if account.update(manager_params[:account_attributes])
        render json: manager
      else
        render json: { errors: manager.errors.full_messages }.to_json, status: :unprocessable_entity
      end
    else
      render json: { errors: "You can't access this manager" }, status: 403
    end
  end

  # DELETE /managers/1
=begin
  def destroy
    manager = Manager.find(params[:id])
    manager.destroy
    head :no_content
  end
=end

  private
    def manager_params
      m_params = params.require(:manager).permit(account_attributes:[:name,:nickname,:email,:birthday,:phone,:address,:password,:password_confirmation])
      m_params[:account_attributes][:uid] = m_params[:account_attributes][:email]
      m_params[:account_attributes][:provider] = "email"
      m_params
    end
end