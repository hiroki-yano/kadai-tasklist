class TasksController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show]
  
  def index
      @tasks = Task.order(id: :desc).page(params[:page]).per(3)
      
        if logged_in?
      @task = current_user.tasks.build  # form_with 用
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
        end
  end

  def show
      @task = Task.find(params[:id])
  end

  def new
      @task = Task.new
  end

  def create
      @task = current_user.tasks.build(task_params)

    if @task.save
      flash[:success] = 'Task が正常に投稿されました'
      redirect_to @task
    else
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'Task が投稿されませんでした'
      render :new
    end
  end

  def edit
      @task = Task.find(params[:id])
  end

  def update
      @task = Task.find(params[:id])

    if @task.update(task_params)
      flash[:success] = 'Task は正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task は更新されませんでした'
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    flash[:success] = 'Task は正常に削除されました'
    redirect_to tasks_url
  end
  
private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:content, :status)
  end

end