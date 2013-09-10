require 'spec_helper'

describe Countries do
  it 'should have a hash where country names are keys and country codes are the values' do
    Countries.supported_by_paypal[:'United States'].should eq(:US)
  end

  it 'should have supported_by_paypal_domestic_txn, which is the same as supported by paypal' do
    Countries.supported_by_paypal_domestic_txn.should eq(Countries.supported_by_paypal)
    Countries.supported_by_paypal_domestic_txn[:China].should eq(:CN)
  end

  it 'should have supported_by_paypal_international_txn, which contains a different code for China' do
    Countries.supported_by_paypal_international_txn.should_not eq(Countries.supported_by_paypal)
    Countries.supported_by_paypal_international_txn[:China].should eq(:C2)
    countries = Countries.supported_by_paypal_international_txn
    countries[:China] = :CN
    countries.should eq(Countries.supported_by_paypal_domestic_txn)
  end
end
