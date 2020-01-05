require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    student_hash = []
    html = Nokogiri::HTML(open(index_url))
    html.css(".student-card").collect{|student|
      hash = {
        name: student.css('h4.student-name').text,
        location: student.css('p.student-location').text,
        profile_url: student.css('a').attribute('href').text
      }
      student_hash << hash
    }
    student_hash
  end

  def self.scrape_profile_page(profile_url)
    student_hash = []
    html = Nokogiri::HTML(open(profile_url))
    html.css('div.social-icon-container a').each {|student|
      url = student.attribute('href')
      student_hash[:twitter_url] = html if html.include?('twitter')
      student_hash[:linkedin_url] = html if html.include?('linkedin')
      student_hash[:github_url] = html if html.include?('github')
      student_hash[:blog_url] = html if student.css('img').attribute("src").text.include?("rss")
    }
    student_hash[:profile_quote] = html.css('div.profile_quote').text
    student_hash[:bio] = html.css('div.description-holder').text
    student_hash
  end

end
