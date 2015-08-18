class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :status, presence: true, inclusion: {in: ["PENDING", "APPROVED", "DENIED"], message: "invalid status" }
  validate :has_no_overlapping_approved_requests

  belongs_to :cat,
    class_name: "Cat",
    foreign_key: :cat_id,
    primary_key: :id


  def overlapping_requests
    where_str = <<-SQL
      (id != :id) AND
          ((start_date > :end_date)
          OR (end_date < :start_date))
    SQL

    CatRentalRequest.where(where_str, :start_date => start_date, :end_date => end_date, :id => id)
  end

  def overlapping_pending_requests
    overlapping_requests.where(status: 'PENDING')
  end

  def overlapping_approved_requests
    overlapping_requests.where(status: 'APPROVED')
  end

  def has_no_overlapping_approved_requests
    unless overlapping_approved_requests.empty? || (self.status == "DENIED")
      errors[:overlapping_request] << "there are overlapping requests for this cat"
    end
  end

  def approve!
    self.transaction do
      overlapping_pending_requests.each(&:deny!)
      self.update!(status: "APPROVED")
    end
  end

  def deny!
    self.update!(status: "DENIED")
  end
end
