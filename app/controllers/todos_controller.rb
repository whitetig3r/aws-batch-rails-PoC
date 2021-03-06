require_relative './concerns/batch_job_submitter'

class TodosController < ApplicationController
  before_action :set_todo, only: %i[show update destroy]
  before_action :submit_job

  # GET /todos
  def index
    @todos = Todo.all
    json_response(@todos)
  end

  # POST /todos
  def create
    @todo = Todo.create!(todo_params)
    json_response(@todo, :created)
  end

  # GET /todos/:id
  def show
    json_response(@todo)
  end

  # PUT /todos/:id
  def update
    @todo.update(todo_params)
    head :no_content
  end

  # DELETE /todos/:id
  def destroy
    @todo.destroy
    head :no_content
  end

  def submitter
    BatchJobSubmitter.instance
  end

  private

  def submit_job
    param_hash = { request_action: http_method(params[:action]) }
    submitter.submit_batch_job(:LOGGER, param_hash)
  end

  def todo_params
    params.permit(:title, :created_by)
  end

  def set_todo
    @todo = Todo.find(params[:id])
  end

end
