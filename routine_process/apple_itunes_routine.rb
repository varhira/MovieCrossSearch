# coding: utf-8
#
# AappleiTunes
#
class AappleiTunesRoutine < BaseRoutine

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