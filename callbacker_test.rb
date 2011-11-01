require './callbacker'

class Tester
  callback :before, :test, :stupid
  #callback :after, :stupid, :thing

  def test
    puts "test"
  end

  def stupid
    puts "stupid"
  end

  #def thing
  #  puts "thing"
  #end
end

t = Tester.new
t.test
