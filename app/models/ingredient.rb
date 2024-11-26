class Ingredient < ApplicationRecord
  belongs_to :ingredient_group
  has_many :product_modifyers, dependent: :destroy
  has_many :ingredient_stocks, dependent: :destroy
end
