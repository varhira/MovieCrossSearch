# coding: utf-8

require "selenium-webdriver"

require './crawl/selector.rb'
require './crawl/crawl.rb'
require './scrape/scrape.rb'
# require './database/database.rb'
# require './database/save_db_task.rb'

#
# AappleiTunes
#
class AappleiTunesStructure < BaseStructure

  # attr_reader :crawl, :scrape, :driver, :selector, :movie_master

  # def initialize(url, site_name)

  #   @crawl  = Crawl.new
  #   @scrape = Scrape.new
  #   # @db_task = SaveDBTask.new

  #   @driver         = @crawl.initialize_driver
  #   @selector       = @crawl.initialize_selector(site_name)
  #   @movie_master   = @scrape.movie_master
  #   # @movie_master = @scrape.initialize_movie_master # DB処理
  #   # @db           = @db_task.initialize_data_base(site_name)

  #  start(url, site_name)

  # end

  def start(url, site_name)

    # トップページを開く
    driver.get(url)

    # カテゴリURLを取得
    category_url_arr = []
    category = driver.find_element(:css, '#genre-nav > div').find_element(:class, 'list').find_elements(:tag_name, 'a')
    category.each do |element|
      url = element.attribute('href')
      category_url_arr << url
    end
    puts category_url_arr

    # TODO(flatba): カテゴリにアクセスして動画情報を取得する
    category_url_arr.each do |category_url|

      # 新規タブを開く

      # 新規タブでcategory_urlを開く

      # 新規タブを開く

      # 動画コンテンツを開く

      # 情報を取得する

      # 取得したらタブを閉じる

    end

  end

end