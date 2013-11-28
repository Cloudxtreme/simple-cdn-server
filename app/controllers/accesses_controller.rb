class AccessesController < ApplicationController

  # GET /
  def index
    @accesses = Access.all
  end

  # GET /accesses/:id
  def show
    @access = Access.find(params[:id])

    SimpleCDN::Configurator::CDN.calculate_size! @access # TODO move this line into ftpd
  end

  # GET /accesses/new
  def new
    @access = Access.new
  end

  # POST /accesses
  def create
    @access = Access.create(get_params)

    if @access.save
      SimpleCDN::Configurator::CDN.create(@access)
      SimpleCDN::Configurator::Nginx.create(@access)

      redirect_to @access
    else
      render 'new'
    end
  end

  # GET /accesses/:id/edit
  def edit
    @access = Access.find(params[:id])
  end

  # PUT   /accesses/:id
  # PATCH /accesses/:id
  def update
    @access = Access.find(params[:id])

    if @access.update(get_params)
      SimpleCDN::Configurator::CDN.update(@access)
      SimpleCDN::Configurator::Nginx.update(@access)

      redirect_to @access
    else
      render 'edit'
    end
  end

  # DELETE /accesses/:id
  def destroy
    @access = Access.find(params[:id])

    unless SimpleCDN::Configurator::CDN.is_empty?(@access)
      flash[:error] = :access_cant_be_destroy
    else
      @access.destroy
      SimpleCDN::Configurator::CDN.destroy!(@access)
      flash[:notice] = :access_destroy
    end

    redirect_to accesses_path
  end

private

  def get_params
    params.require(:access).permit(:identifier, :domain, :quotas, :password)
  end
end
