class CompaniesController < ApplicationController
    def index
        @companies = Company.all
    end
  
    def search
      @query = params[:query]
      @companies = @query.present? ? Company.search_by_query(@query) : Company.none
      
      response.headers["Cache-Control"] = "no-store"

      respond_to do |format|
        format.turbo_stream
        format.html { render partial: "companies/search_results", locals: { companies: @companies } }
      end
    end
  end
  