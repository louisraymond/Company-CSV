require "csv"

class Admin::CompaniesController < ApplicationController
  def index
  end

  def import  
    file = params[:file]
  
    if file.blank?
      flash[:alert] = "No file provided!"
    end
  
    unless file.content_type == "text/csv" || File.extname(file.original_filename) == ".csv"
      flash[:alert] = "Invalid file type. Please upload a valid CSV file."
    end
  
    success_count = 0
    error_count = 0
  
    begin
      CSV.foreach(file.path, headers: true, col_sep: ";") do |row|
        company_data = row.to_hash.symbolize_keys
  
        company = Company.find_or_initialize_by(registry_number: company_data[:coc_number])
  
        if company.update(
            name: company_data[:company_name],
            city: company_data[:city]
          )
          success_count += 1
        else
          error_count += 1
          Rails.logger.error("Failed to import row: #{row.inspect}. Errors: #{company.errors.full_messages}")
        end
      end
  
      flash[:notice] = "CSV import completed! #{success_count} records imported, #{error_count} failed."
    rescue StandardError => e
      Rails.logger.error("CSV Import Failed: #{e.message}")
      flash[:alert] = "An error occurred during import: #{e.message}"
    end
  
    redirect_to root_path
  end

  # Another issue is that if you run this process, and move on, the rails app still does the thing
end