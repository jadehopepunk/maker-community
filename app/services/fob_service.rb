class FobService
  def touch(device_id)
    fob = get_fob(device_id)
  end

  private

  def get_fob(device_id)
    Fob.where(device_id: device_id).first_or_create
  end
end
