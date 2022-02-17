module UsersHelper

  def is_valid?(object)
    if object.nil?
      ""
    else
      if object.valid?
        "is-valid"
      else
        "is-invalid"
      end
    end
  end

end
