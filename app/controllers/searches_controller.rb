class SearchesController < ApplicationController

  authorize_resource

  def show
    @resource = params[:resource]
    @search_string = params[:search]
    @result = Search.execute(@search_string, @resource)
    render 'show'
  end
end