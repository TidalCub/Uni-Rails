
Feature: Ordering an item

#Tests requierment F-2 F-3 F-8 F-9
@javascript 
Scenario: Order an item
Given There is an item
And Im on the menu page
And There is a user
And I am logged in
When I click "Add to Order"
And I click "cart"
Then I should see the item in my Cart
When I click "Continue To Checkout"
Then I should see the checkout page
When I click "Pay"
Then I should see the order confirmation page
And The order should have the status "paid"
Then The order should apear on the screen
When I click complete
Then The order is completed

@javascript
Scenario: When the user is not loged in
Given There is an item
And Im on the menu page
Then I cant see "Add to Order"

#Satifyies requierment F-5
@javascript
Scenario: When the user modifies a product
Given There is an item
And Im on the menu page
And There is a user
And I am logged in
When I click "view & Customise"
Then I should see the ingridients i can change
When I change the "milk" to "Oat Milk"
And I click "Save and Add to Basket"
And I click "cart"
Then I should see the item in my Cart
And I should see the "Oat Milk" in the ingridients
