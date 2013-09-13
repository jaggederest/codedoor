module ModelTestHelper
  def ensure_inclusion_only_of(model, attribute, values)
    # NOTE: Grabbed from Stack Overflow.  Perhaps there is a better way.
    inclusion_validator = model._validators[attribute].detect{ |validator|
      validator.is_a?(ActiveModel::Validations::InclusionValidator)
    }
    acceptable_values = inclusion_validator.options[:in] rescue nil
    acceptable_values.sort.should eq(values.sort)
  end

  def validate_ability_of_programmer_resume_item(object_type)

    user = FactoryGirl.create(:user)
    programmer = FactoryGirl.create(:programmer, user: user)
    ability = Ability.new(user)

    # It should allow users to manage their own items
    item = FactoryGirl.create(object_type, programmer: programmer)
    ability.should be_able_to(:read, item)
    ability.should be_able_to(:create, item)
    ability.should be_able_to(:update, item)
    ability.should be_able_to(:destroy, item)

    # It should allow users to only view other people's items
    item = FactoryGirl.create(object_type, programmer: FactoryGirl.create(:programmer))
    ability.should be_able_to(:read, item)
    ability.should_not be_able_to(:create, item)
    ability.should_not be_able_to(:update, item)
    ability.should_not be_able_to(:destroy, item)

    # It should allow users to only view items if there is no programmer account
    ability = Ability.new(FactoryGirl.create(:user, programmer: nil))
    item = FactoryGirl.create(object_type)
    ability.should be_able_to(:read, item)
    ability.should_not be_able_to(:create, item)
    ability.should_not be_able_to(:update, item)
    ability.should_not be_able_to(:destroy, item)

    # It should allow logged out users to only view items
    ability = Ability.new(nil)
    item = FactoryGirl.create(object_type)
    ability.should be_able_to(:read, item)
    ability.should_not be_able_to(:create, item)
    ability.should_not be_able_to(:update, item)
    ability.should_not be_able_to(:destroy, item)
  end
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include ModelTestHelper, type: :model
end
