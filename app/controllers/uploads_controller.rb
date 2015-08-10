class UploadsController < ApplicationController
  def index
  end

  def import
    total = Importer.import(params[:file])
    redirect_to uploads_url, notice: "Data imported. Total revenue: #{total}"
  end


end
