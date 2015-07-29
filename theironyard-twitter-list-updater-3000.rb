require 'mechanize'

if `which t`.gsub(' ', '').gsub(/\n/, '') == ""
  puts "You need to install the t command line tool as per https://github.com/sferik/t"
  exit
end

exit

url = 'http://theironyard.com/about/team/'

#find all 'bio' get text of h2
#find text of ul.links a with 'twitter'
#

class Ironyardigan

  attr_reader :name, :twitter

  def initialize name, twitter
    @name = name
    @twitter = twitter
  end

  def to_s
    [name, twitter].join(": ")
  end

end


tiy = []

agent = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }

agent.get(url) do |page|

  page.search(".bio").each do |bio|


    text = bio.search("h2").text
    twitter = bio.search("ul.links a").find{|l| l["href"] =~ /twitter/ }

    tiy << Ironyardigan.new(text, twitter.text) if twitter

  end
end

unless `t lists` =~ /tiy/
  `t list create tiy`
end


`t list add tiy #{ tiy.map(&:twitter).join(" ") } ` 
