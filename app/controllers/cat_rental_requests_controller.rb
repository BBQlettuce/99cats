class CatRentalRequestsController < ApplicationController
  def new
    @cats = Cat.all
    render :new
  end

  def create
    rental_request = CatRentalRequest.new(rental_params)
    if rental_request.save!
      redirect_to cat_url(rental_params[:cat_id])
    else
      render :new
    end
  end


  private

  def rental_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date)
  end
end
