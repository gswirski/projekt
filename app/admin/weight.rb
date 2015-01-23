ActiveAdmin.register Weight do
  menu false

  scope_to do
    current_user
  end

  permit_params :weight

  controller do
    def index
      redirect_to root_path
    end

    def show
      redirect_to root_path
    end
  end
end
