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

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:notice] = 'Record saved successfully.'
      redirect_to tasks_path
    else
      flash[:alert] = 'Data invalid. Record not saved.'
      render 'new'
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_path
  end

  private

    def task_params
      params.require(:task).permit!
    end

end
