# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :products, dependent: :destroy
  has_many :menu, through: :products
end
