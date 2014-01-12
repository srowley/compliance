class TasksController < ApplicationController
  
  def export
    respond_to do |format|
      format.html
      format.csv { render text: Task.to_csv(params[:filter]) }
    end
  end
  
  def filter 
    @tasks = Task.filter(params['filter'], current_user)
    render 'index'
  end

  def index
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      @task.owner = User.find(params[:role]['owner'])
      flash[:notice] = 'Record updated successfully.'
      redirect_to task_path(@task) 
    else
      flash.now.alert = 'Update invalid. Record not saved.'
      render 'edit'
    end
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      @task.owner = User.find(params[:role]['owner'])
      flash[:notice] = 'Record saved successfully.'
      redirect_to tasks_path
    else
      flash.now.alert = 'Data invalid. Record not saved.'
      render 'new'
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_path
  end

  def subscribe
    @task = Task.find(params[:id])
    User.find(params[:role]['subscriber']).add_role :subscriber, @task
    redirect_to edit_task_path(@task)  
  end

  def unsubscribe
    @task = Task.find(params[:id])
    User.find(params[:user_id]).remove_role :subscriber, @task
    redirect_to edit_task_path(@task)
  end

  private

    def task_params
      params.require(:task).permit!
    end
      
end
