class Company < ApplicationRecord
    validates :registry_number, uniqueness: true
  
    scope :search_by_query, ->(query) {
      return none if query.blank?
    
      where(
        "LOWER(name) LIKE :q OR LOWER(city) LIKE :q OR LOWER(registry_number) LIKE :q",
        q: "%#{sanitize_sql_like(query.downcase)}%"
      )
    }
    
  end
  