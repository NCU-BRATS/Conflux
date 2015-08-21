module PlannableConcern
  extend ActiveSupport::Concern

  def plannable_begin_time
    begin_at
  end

  def plannable_due_time
    due_at
  end

  def working?
    plannable_begin_time <= Time.now and Time.now <= plannable_due_time
  end

  def expired?
    Time.now > plannable_due_time
  end

  def finished?
    Time.now > plannable_due_time
  end

  def planned?
    plannable_begin_time.present? and plannable_due_time.present?
  end

  def due_time_duration
    planned? ? ( ( Time.now - plannable_due_time ) / 1.day ).to_i.abs : 0
  end

end
