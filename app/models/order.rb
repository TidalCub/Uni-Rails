# frozen_string_literal: true

class Order < ApplicationRecord
  include AASM
  belongs_to :user
  belongs_to :store
  has_many :order_items, dependent: :destroy

  enum :state, { new_order: 0, pending: 1, on_checkout: 2, paid: 3, payment_failed: 4, completed: 5, expired: 6 }

  def total
    order_items.sum { |item| item.product.price }
  end

  aasm column: :state, enum: true do
    state :new_order, initial: true
    state :pending, :on_checkout, :paid, :completed, :expired, :payment_failed

    event :pending do
      transitions from: %i[new_order pending checkout], to: :pending
    end

    event :checkout do
      transitions from: %i[new_order pending on_checkout], to: :on_checkout
      after do
        stripe_payment_intent = StripePaymentintentService.new(stripe_total_price, user, self)
        if payment_intent.present? && client_secret.present?
          stripe_payment_intent.update(payment_intent)
        else
          payment_intent = stripe_payment_intent.create
          self.payment_intent = payment_intent.id
          self.client_secret = payment_intent.client_secret
          save
        end
      end
    end

    event :pay do
      transitions from: :pending, to: :paid
    end

    event :complete do
      transitions from: :paid, to: :completed
    end
  end

  def stripe_total_price
    (total * 100).to_i
  end
end
