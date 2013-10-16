require 'spec_helper'

describe ProgrammerSearch do

  before :each do
    js = Skill.find_by_name('JavaScript')
    c = Skill.find_by_name('C')
    @js_programmer = FactoryGirl.create(:programmer, visibility: 'public', state: 'activated', qualified: true, skills: [js], rate: 50, contract_to_hire: true)
    @c_programmer = FactoryGirl.create(:programmer, visibility: 'public', state: 'activated', qualified: true, skills: [c], rate: 100)
    @part_time_programmer = FactoryGirl.create(:programmer, visibility: 'public', state: 'activated', qualified: true, rate: 200, availability: 'part-time')
    @unqualified_programmer = FactoryGirl.create(:programmer, qualified: false)
  end

  context 'skill' do
    it 'should return a skill when the parameter matches' do
      ps = ProgrammerSearch.new({skill_name: 'C'}, true)
      ps.skill.should eq(Skill.find_by_name('C'))
      ps.skill.name.should eq('C')
      ps.programmers.should eq([@c_programmer])
    end

    it 'should return nil as the skill when the parameter does not match' do
      ps = ProgrammerSearch.new({skill_name: 'Not a real skill'}, true)
      ps.skill.should be_nil
      ps.programmers.should eq([@js_programmer, @c_programmer, @part_time_programmer])
    end

    it 'should be nil when the parameter is not present' do
      ps = ProgrammerSearch.new({}, true)
      ps.skill.should be_nil
    end
  end

  context 'skill_name' do
    it 'should return the skill name when the parameter matches' do
      ps = ProgrammerSearch.new({skill_name: 'Android'}, true)
      ps.skill_name.should eq('Android')
    end

    it 'should be nil when the parameter does not match' do
      ps = ProgrammerSearch.new({skill_name: 'Not a real skill'}, true)
      ps.skill_name.should eq('')
    end

    it 'should be nil when the parameter is not present' do
      ps = ProgrammerSearch.new({}, true)
      ps.skill_name.should eq('')
    end
  end

  context 'availability' do
    it 'should be set when the value is part-time' do
      ps = ProgrammerSearch.new({availability: 'part-time'}, true)
      ps.availability.should eq('part-time')
      ps.programmers.should eq([@part_time_programmer])
    end

    it 'should be nil when the value is unavailable' do
      ps = ProgrammerSearch.new({availability: 'any'}, true)
      ps.availability.should be_nil
      ps.programmers.should eq([@js_programmer, @c_programmer, @part_time_programmer])
    end

    it 'should be nil when the parameter is not present' do
      ps = ProgrammerSearch.new({}, true)
      ps.availability.should be_nil
    end
  end

  context 'min_rate' do
    it 'should be integer when input is integer' do
      ps = ProgrammerSearch.new({min_rate: '50'}, true)
      ps.min_rate.should eq(50)
    end

    it 'should be float when input is float' do
      ps = ProgrammerSearch.new({min_rate: '50.1'}, true)
      ps.min_rate.should eq(50.1)
    end

    it 'should show a $100/hr programmer if min_rate is 112' do
      # 112 will show $100/hr programmers because of the cut that goes to CodeDoor
      ps = ProgrammerSearch.new({min_rate: '112'}, true)
      ps.programmers.should eq([@c_programmer, @part_time_programmer])
    end

    it 'should not show a $100/hr programmer if min_rate is 113' do
      ps = ProgrammerSearch.new({min_rate: '113'}, true)
      ps.programmers.should eq([@part_time_programmer])
    end

    it 'should be nil when not a number' do
      ps = ProgrammerSearch.new({min_rate: 'not-a-number'}, true)
      ps.min_rate.should be_nil
      ps.programmers.should eq([@js_programmer, @c_programmer, @part_time_programmer])
    end

    it 'should be nil when not present' do
      ps = ProgrammerSearch.new({}, true)
      ps.min_rate.should be_nil
    end
  end

  context 'max_rate' do
    it 'should be integer when input is integer' do
      ps = ProgrammerSearch.new({max_rate: '50'}, true)
      ps.max_rate.should eq(50)
    end

    it 'should be float when input is float' do
      ps = ProgrammerSearch.new({max_rate: '50.1'}, true)
      ps.max_rate.should eq(50.1)
    end

    it 'should not show a $100/hr programmer if max_rate is 112' do
      # 112 will not show $100/hr programmers because of the cut that goes to CodeDoor
      ps = ProgrammerSearch.new({max_rate: '112'}, true)
      ps.programmers.should eq([@js_programmer])
    end

    it 'should show a $100/hr programmer if min_rate is 113' do
      ps = ProgrammerSearch.new({max_rate: '113'}, true)
      ps.programmers.should eq([@js_programmer, @c_programmer])
    end

    it 'should be nil when not a number' do
      ps = ProgrammerSearch.new({miaxrate: 'not-a-number'}, true)
      ps.max_rate.should be_nil
      ps.programmers.should eq([@js_programmer, @c_programmer, @part_time_programmer])
    end

    it 'should be nil when not present' do
      ps = ProgrammerSearch.new({}, true)
      ps.max_rate.should be_nil
    end
  end

  context 'contract_to_hire' do
    it 'should be true when the value is present' do
      ps = ProgrammerSearch.new({contract_to_hire: '1'}, true)
      ps.contract_to_hire.should be_true
      ps.programmers.should eq([@js_programmer])
    end

    it 'should be false when the value is blank' do
      ps = ProgrammerSearch.new({contract_to_hire: ''}, true)
      ps.contract_to_hire.should be_false
      ps.programmers.should eq([@js_programmer, @c_programmer, @part_time_programmer])
    end

    it 'should be false when the parameter is not present' do
      ps = ProgrammerSearch.new({}, true)
      ps.contract_to_hire.should be_false
    end
  end

end
