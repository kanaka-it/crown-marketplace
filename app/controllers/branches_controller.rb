class BranchesController < ApplicationController
  def index
    search_scope = Branch.includes(:supplier)

    if params[:postcode].nil?
      @branches = search_scope.all
      return
    end

    @postcode = UKPostcode.parse(params[:postcode])

    unless @postcode.valid?
      display_error('Postcode is invalid')
      return
    end

    @point = Geocoding.new.point(postcode: @postcode.to_s)

    unless @point
      display_error("Couldn't find that postcode")
      return
    end

    @branches = search_scope.near(@point, within_metres: helpers.miles_to_metres(Branch::DEFAULT_SEARCH_RANGE_IN_MILES))
  end

  private

  def display_error(message)
    flash[:error] = message
    redirect_to search_path(params.permit(:nominated_worker, :postcode))
  end
end
