class AccessesController < ApplicationController

  def index
    @accesses = Access.all
  end

  def show
    @access = Access.find(params[:id])
  end

  def new
    @access = Access.new
  end

  def create
    @access = Access.create(params[:access].permit(:identifier))

    if @access.save
      redirect_to @access
    else
      render 'new'
    end
  end

  def edit
    @access = Access.find(params[:id])
  end

  def update
    @access = Access.find(params[:id])

    if @access.update(params[:access].permit(:identifier))
      redirect_to @access
    else
      render 'edit'
    end
  end
end
