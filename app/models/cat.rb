class Cat < ActiveRecord::Base
  ALLOWED_COLORS = [:orange, :black, :white, :gray, :brown]
  validates :color, presence: true, inclusion: { in: ALLOWED_COLORS, message: "color not allowed" }
  validates :name, presence: true
  validates :sex, presence: true, inclusion: { in: ["M", "F"], message: "invalid gender"}
  validates :birth_date, presence: true
end
