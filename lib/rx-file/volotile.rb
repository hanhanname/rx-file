module RxFile

  # Volotile module keeps track of attributes that are not menat to be written
  # The idea being similar to private methods. So not every little detail is relevant
  # for the object. Some attribuets may be calculated, cached etc,
  #
  # There is only one useful call for the user, "add" attributes for a given class
  #
  module Volotile
    @@mapping = {    }

    # Add attributes that are then ommited from the rxf writing process
    # The clazz is the real class object (eg String), and thus the
    # adding must happen after the class definition, often at the end of the file
    # attributes are an array of Symbols
    def self.add clazz , attributes
      @@mapping[clazz] = attributes
    end

    private
    # return the volotile attributes as an array (or empty array)
    def self.attributes clazz
      @@mapping[clazz] || []
    end

  end
end
