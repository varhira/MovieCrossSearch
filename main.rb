# coding: utf-8

require 'robotex'
# require 'sqlite3'

require "date"
require 'dotenv'

# Import File
# require './entry_crawl.rb'
# require './routine_stracture.rb'
require './crawl/selector.rb'

# Structure File
require './routine_structure/hulu_structure.rb'
require './routine_structure/netflix_structure.rb'
require './routine_structure/amazon_prime_structure.rb'
require './routine_structure/amazon_structure.rb'
require './routine_structure/gayo_structure.rb'
require './routine_structure/dtv_structure.rb'
require './routine_structure/apple_music_structure.rb'
require './routine_structure/microsoft_structure.rb'
require './routine_structure/googleplay_structure.rb'
require './routine_structure/mubi_structure.rb'


class EntryCrawl

  # attr_reader :base_url, :site_name, :selector, :db, :driver, :wait, :movie_master, :genre_master, :director_master, :cast_master
  attr_reader :base_url, :site_name, :selector, :driver, :wait, :movie_master, :genre_master, :director_master, :cast_master

   # 初期データの生成
   def initialize(url)
     @base_url = url
     @site_name = ""
     @genre_master    = []
     @director_master = []
     @cast_master     = []
   end

   def check_robot(url)
     # クロール可能サイトかどうかチェックする
     robotex = Robotex.new
     p robotex.allowed?(url)
   end

   # クロールするサイトの名称を判断して、
   # メインストラクチャーを実行する
   def detect_site_name_and_start_crawl(url)
     if url.include?('happyon')
       @site_name = 'hulu'
       hulu_structure = HuluStructure.new
       hulu_structure.start(url, @site_name)

     elsif url.include?('netflix')
       @site_name ='netflix'
       netflix_structure = NetflixStructure.new
       netflix_structure.start(url, @site_name)

     elsif url.include?('Prime-Video')
       @site_name = 'amazon_prime'
       amazon_prime_structure = AmazonPrimeStructure.new
       amazon_prime_structure.start(@site_name)

     elsif url.include?('Amazon')
       @site_name = 'amazon_video'
       amazon_video_structure = AmazonVideoStructure.new
       amazon_video_structure.start(@site_name)

     elsif url.include?('gyao')
       @site_name = 'gyao'
       gyao_structure = GyaoStructure.new
       gyao_structure.start(@site_name)

     elsif url.include?('dmkt')
       @site_name = 'dtv'
       dtv_structure = DtvStructure.new
       dtv_structure.start(@site_name)

     elsif url.include?('unext')
       @site_name = 'unext'
       unext_structure = UnextStructure.new
       unext_structure.start(@site_name)

     elsif url.include?('apple iTunes')
       @site_name = 'apple_itunes'
       apple_itunes_structure = AppleMusicStructure.new
       apple_itunes_structure.start(@site_name)

     elsif url.include?('Microsoft')
       @site_name = 'ms_video'
       ms_video_structure = MsVideoStructure.new
       ms_video_structure.start(@site_name)

     elsif url.include?('GooglePlay')
       @site_name = 'googleplay'
       googleplay_structure = GooglePlayStructure.new
       googleplay_structure.start(@site_name)

     elsif url.include?('mubi')
       @site_name = 'mubi'
       mubi_structure = MubiStructure.new
       mubi_structure.start(@site_name)

     end
     puts "URLエラー"
   end

end

Dotenv.load
# HULU_URL NETFLIX_URL AMAZON_PRIME_URL AMAZON_VIDEO_URL GYAO_URL DTV_URL UNEXT_URL APPLE_ITUNES_URL MICROSOFT_URL GOOGLEPLAY_URL MUBI_URL
url = "NETFLIX_URL"

# クローラーのインスタンス化
entry = EntryCrawl.new(ENV[url])

# サイトのクロール可否のチェック
entry.check_robot(entry.base_url)

# サイトの種別を判断し、クローラを開始する
entry.detect_site_name_and_start_crawl(entry.base_url)
