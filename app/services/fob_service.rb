class FobService
  def touch(device_id)
    fob = get_fob(device_id)
    fob_session = current_session(fob)

    if fob_session
      stop_session(fob_session)
    else
      fob_session = start_session(fob)
    end

    fob_session
  end

  private

  def get_fob(device_id)
    Fob.where(device_id: device_id).first_or_create
  end

  def current_session(fob)
    fob.sessions.open.first
  end

  def start_session(fob)
    fob.sessions.create(opened_at: Time.current)
  end

  def stop_session(fob_session)
    fob_session.update(closed_at: Time.current)
  end
end
