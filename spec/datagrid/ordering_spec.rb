require 'spec_helper'

describe Datagrid::Ordering do


  let!(:first) { Entry.create!(:name => "aa")}
  let!(:second) { Entry.create!(:name => "bb")}
  let!(:third) { Entry.create!(:name => "cc")}


  it "should support order" do
    test_report(:order => "name") do
      scope do
        Entry
      end
      column :name
    end.assets.should discover(first, second, third).with_exact_order

  end

  it "should support desc order" do
    test_report(:order => "name", :descending => true) do
      scope do
        Entry
      end
      column :name
    end.assets.should discover(third, second, first).with_exact_order


  end


  it "should raise error if ordered by not existing column" do
    lambda {
      test_report(:order => :hello)
    }.should raise_error(Datagrid::OrderUnsupported)
  end

  it "should raise error if ordered by column without order" do
    lambda do
      test_report(:order => :category) do
        filter(:category, :default, :order => false) do |value|
          self
        end
      end
    end.should raise_error(Datagrid::OrderUnsupported)
  end

  it "should override default order" do

    test_report(:order => :id) do
      scope { Entry.order("id desc")}
      column(:id) do
        self.order("id asc")
      end
    end.assets.should discover(first, second, third).with_exact_order
  end

end
