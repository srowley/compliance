class TasksController < ApplicationController

  def index
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to @task
    else
      flash[:alert] = 'Update invalid. Record not saved.'
      render 'edit'
    end
  end

  private

    def task_params
      params.require(:task).permit!
    end

end
