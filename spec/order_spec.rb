require 'order'

describe Order do

  let(:shroyu) { double(:menu, dishes: {"Chilli Chicken Ramen" => 7.5, "Duck Gyoza" => 4, "Pepper Squid" => 5.5 } ) }
  subject(:order) { described_class.new(shroyu) }
  let (:message) { double(:message) }

  describe '#initialize' do
    it 'is has no orders' do
      expect(order.my_order).to be_empty
    end
  end

  describe '#add' do
    it 'adds dish and quantity to my orders' do
      order.add("Duck Gyoza", 2)
      expect(order.my_order).to eq [{"Duck Gyoza" => 2}]
    end
    it 'raises an error if menu does not include the dish' do
      message = "Please order something from the menu!"
      expect { order.add("Olives", 1) }.to raise_error message
    end
    it 'returns a string confirming dish and quantity added to basket' do
      message = "1X Chilli Chicken Ramen has been added to your basket"
      expect(order.add("Chilli Chicken Ramen", 1)).to eq message
    end
  end

  describe '#view_basket' do
    it 'shows the contents of your basket' do
      order.add("Duck Gyoza", 1)
      order.add("Pepper Squid", 2)
      expect(order.view_basket). to eq "1X Duck Gyoza - £4.00\n2X Pepper Squid - £11.00\n"
    end
  end

  describe '#total' do
    it 'shows the total sum of your basket' do
      order.add("Duck Gyoza", 1)
      order.add("Pepper Squid", 2)
      expect(order.total).to eq "Your total is £15.00"
    end
  end

  describe '#checkout' do
    it 'returns an error if incorrect amount' do
      order.add("Duck Gyoza", 1)
      order.add("Pepper Squid", 2)
      order.total
      message = "Incorrect amount"
      expect { order.checkout(11) }.to raise_error message
    end
  end

  describe '#confirmation' do
    it 'sends a payment confirmation text message' do
      allow(message).to receive(:send).and_return true
      order.add("Duck Gyoza", 1)
      order.add("Pepper Squid", 2)
      order.total
      expect(order.checkout(15)).to eq "Order has been placed. We will text you with the delivery time"
    end
  end

end
