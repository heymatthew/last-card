class PickupsController < ApplicationController
  before_filter :setup_round

  def create
    cards = pickup_params[:cards].map { |h| Card.from_hash(h) }
    pickup_service = PickupCards.new(cards)

    if pickup_service.call
      render_success
    else
      render_errors(pickup_service.errors)
    end
  end

  private

  def pickup_params
    #params.require(:pickup).permit(cards: [ :suit, :rank ])
    params.require(:pickup).permit(cards: [ :suit, :rank ])
  end
end
