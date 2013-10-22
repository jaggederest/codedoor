class JobMessage < ActiveRecord::Base
  belongs_to :job

  #validates :job_id, presence: true
  validates :content, presence: true

  def sender_name
    sender_is_client ? job.client.user.full_name : job.programmer.user.full_name
  end

  def created_at_text
    created_at.strftime('%B %-d')
  end
end
