class CatRentalRequestsController < ApplicationController
  before_action :check_if_your_cat, only: [:deny, :approve]

  def check_if_your_cat
    cat = Cat.find(rental_params[:cat_id])
    redirect_to cats_url if cat.user_id != current_user.id
  end

  def new
    @cats = Cat.all
    render :new
  end

  def create
    rental_request = CatRentalRequest.new(rental_params.merge({ requester_id: current_user.id}))
    if rental_request.save!
      redirect_to cat_url(rental_params[:cat_id])
    else
      render :new
    end
  end

  def deny
    @cat_rental_request = CatRentalRequest.find(params[:id])
    @cat_rental_request.deny!
    redirect_to cat_url(@cat_rental_request.cat_id)
  end

  def approve
    @cat_rental_request = CatRentalRequest.find(params[:id])
    @cat_rental_request.approve!
    redirect_to cat_url(@cat_rental_request.cat_id)
  end

  private

  def rental_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date)
  end
end
