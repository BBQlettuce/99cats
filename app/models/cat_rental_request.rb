class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :status, presence: true, inclusion: {in: ["PENDING", "APPROVED", "DENIED"], message: "invalid status" }
  

  belongs_to
    :cat,
    class_name: "Cat",
    foreign_key: :cat_id,
    primary_key: :id


  def overlapping_requests
    where_str = <<-SQL
      (id != :id) AND
          ((start_date BETWEEN :start_date AND :end_date)
          OR (end_date BETWEEN :start_date AND :end_date))
    SQL

    CatRentalRequest.where(where_str, :start_date => start_date, :end_date => end_date, :id => id)
  end

  def overlapping_approved_requests
    overlapping_requests.where(" status = 'APPROVED' ")
  end

end
