class ProgrammerSearch
  attr_reader :skill
  attr_reader :skill_name
  attr_reader :availability
  attr_reader :min_rate
  attr_reader :max_rate
  attr_reader :contract_to_hire
  attr_reader :programmers

  def initialize(params, user_signed_in)
    @skill = Skill.find_by_name(params[:skill_name]) unless params[:skill_name].blank?
    if @skill
      @programmers = Programmer.joins(:skills).where('skills.id = ?', skill.id)
      @skill_name = @skill.name
    else
      @programmers = Programmer
      @skill_name = ''
    end
    @programmers = @programmers.where('state = ? AND qualified = ? AND visibility IN (?)', 'activated', true, user_signed_in ? ['codedoor', 'public'] : ['public'])

    @availability = params[:availability]
    if availability_chosen?
      @programmers = @programmers.where('availability = ?', @availability)
    else
      @programmers = @programmers.where('availability IN (?)', ['full-time', 'part-time'])
    end

    @min_rate = string_to_rate(params[:min_rate])
    @max_rate = string_to_rate(params[:max_rate])
    @programmers = @programmers.where('rate >= ?', Programmer.client_rate_to_programmer_rate(@min_rate)) if @min_rate
    @programmers = @programmers.where('rate <= ?', Programmer.client_rate_to_programmer_rate(@max_rate)) if @max_rate

    @contract_to_hire = params[:contract_to_hire].present?
    @programmers = @programmers.where('contract_to_hire = ?', true) if @contract_to_hire
  end

  def availability_chosen?
    @availability == 'full-time' || @availability == 'part-time'
  end

  private

  def string_to_rate(rate_string)
    if rate_string.to_f > 0.0
      rate_string.to_i == rate_string.to_f ? rate_string.to_i : rate_string.to_f.round(2)
    else
      nil
    end
  end
end
