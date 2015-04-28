module CloseableConcern
  extend ActiveSupport::Concern

  included do

    include AASM

    aasm :column => 'status' do

      state :open, :initial => true
      state :closed

      event :close do
        transitions :from => :open, :to => :closed
        before do
          before_close
        end
      end

      event :reopen do
        transitions :from => :closed, :to => :open
        before do
          before_reopen
        end
      end

    end

  end

  def closeable_begin_time
    begin_at
  end

  def closeable_due_time
    due_at
  end

  def working?
    closeable_begin_time <= Time.now and Time.now <= closeable_due_time
  end

  def expired?
    Time.now > closeable_due_time and open?
  end

  def finished?
    Time.now > closeable_due_time and closed?
  end

  def planned?
    closeable_begin_time.present? and closeable_due_time.present?
  end

  def due_time_duration
    planned? ? ( ( Time.now - closeable_due_time ) / 1.day ).to_i.abs : 0
  end

  def before_close
  end

  def before_reopen
  end

end
