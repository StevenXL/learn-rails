class Example < Object                                     # our class inherits from the Object class; this is not stricly necessary.

  # This is a comment

  attr_accessor :honorific                                 # The best practice is to seperate these into their own line, instead of writing them all in one line
  attr_accessor :name
  attr_accessor :date

  def initialize(name, date)                               # When you call the new method on a class, it will set up the object, and immediately run the initialize method, passing in the parameters
    @name = name
    @date = date.nil? ? Date.today : date                  # This is syntatic sugar, it means condition ? if_true_execute_this : otherwise_execute_this
  end

  def backwards_name                                       # We are calling the reverse method on a string; notice that there is no explicit return
    @name.reverse
  end

  def to_s                                                 # Here, we are overridding the default to_s method (defined in the Object class) by naming the method exactly the same in the Example class
    @name
  end

  def titled_name                                          # This example is just to show an example of string interpolation
    @honorific ||= 'Esteemed'
    titled_name = "#{@honorific} #{@name}"
  end

  def  december_birthdays                                  # This example illustrates iteration over a collection, as well as the shovel operator to push onto an array
    born_in_december = Array.new 
    famous_birthdays.each do |name, date|
      if date.month == 12
        born_in_december << name
      end
    end

    born_in_december
  end

  private                                                  # Methods defined after the private keyword are only available to methods inside our class or inside a sub-class

  def famous_birthdays                                     # This example is to illustrate what a hash is
    birthdays = {
      'Ludwig Van Beethoven' => Date.new(1770, 12, 16),
      'Dave Brubeck' => Date.new(1920, 12, 6),
      'Buddy Holly' => Date.new(1936, 9, 7),
      'Keith Richards' => Date.new(1943, 12, 18) 
    }
  end

end
