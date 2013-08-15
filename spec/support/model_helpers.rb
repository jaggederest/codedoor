module ModelTestHelper
  def ensure_inclusion_only_of(model, attribute, values)
    # NOTE: Grabbed from Stack Overflow.  Perhaps there is a better way.
    inclusion_validator = model._validators[attribute].detect{ |validator|
      validator.is_a?(ActiveModel::Validations::InclusionValidator)
    }
    acceptable_values = inclusion_validator.options[:in] rescue nil
    expect(acceptable_values.sort).to eq(values.sort)
  end
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include ModelTestHelper, type: :model
end
