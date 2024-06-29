class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    # @tasks = current_user.tasks.order(created_at: :desc)
    @q = current_user.tasks.ransack(params[:q])
    @tasks = @q.result(distinct: true)
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  # なんでupdateとdestroyの変数はインスタンス変数じゃないんだ？
  # >特に意味はない。インスタンス変数で書いても問題ない。
  def update
    @task.update!(task_params)
    redirect_to tasks_url, notice: "タスク「#{@task.name}を更新しました」"
  end

  def destroy
    # @task = current_user.tasks.find(params[:id])
    @task.destroy
    redirect_to tasks_url, notice: "タスク「#{@task.name}を削除しました」"
  end

  def create
    @task = current_user.tasks.new(task_params)
    if params[:back].present?
      render :new, status: :accepted
      return
    end
    if @task.save
      TaskMailer.creation_email(@task).deliver_now
      redirect_to @task, notice: "タスク「#{@task.name}を登録しました。」"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def confirm_new
    @task = current_user.tasks.new(task_params)
    if @task.valid?
      render :confirm_new, status: :accepted
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def task_params
    params.require(:task).permit(:name, :description)
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end
end

