# coding: utf-8
#
# Netflix
#
class NetflixRoutine < BaseRoutine

  attr_reader :crawl, :scrape, :driver, :selector, :movie_master

  # カテゴリURLを取得する
  def get_category_url()
    category_url_arr = []
    category = driver.find_element(:class, 'tabbed-primary-navigation')
    category.find_elements(:class => 'navigation-tab').each do |element|
      # puts a_tag.text.strip   # カテゴリ名称
      # puts a_tag.attr('href') # カテゴリURL
      category_url_arr << element.find_element(:tag_name, 'a').attribute('href') # URLを取得する
    end
    return category_url_arr
  end

  # ジャンルURLを取得する
  def get_genre_url
    genre_url_arr = []
    genre_arr = driver.find_element(:css, '#appMountPoint > div > div > div.pinning-header > div > div.sub-header > div:nth-child(2) > div > div > div.aro-genre-details > div.subgenres > div > div.sub-menu.theme-lakira').find_elements(:tag_name, 'a')
    genre_arr.each do |genre|
      puts genre.text
      genre_url_arr << genre.attribute('href')
    end
    return genre_url_arr
  end

  # URLからジャンルIDを切り出す
  def get_genre_id(genre_url)
    return genre_url[genre_url.rindex('genre/')+('genre/'.length)..genre_url.length]
  end

  # 読み込もうとしているジャンルidが読み込み済でないかチェックする
  # def check_duplicate_genre_id(genre_url)
    # genre_id = get_genre_id(genre_url)
    # if @genre_id_list.include?(genre_id)
    #   true
    # else
    #   @genre_id_list << genre_id
    # end
  # end

  def save_contents
    # TODO(flatba): 動画情報を取得する
    # ジャンルidが同じ場合は飛ばしても良い
    # ただし、映画一本に複数のジャンルidが紐づくことは考慮する必要あり。
  end

  #
  # main routine
  #
  def start(url, site_name)
    super

    # ログインする
    login(url, driver, selector, ENV['NETFLIX_LOGIN_ID'], ENV['NETFLIX_LOGIN_PASSWORD'])
    # ログイン後に視聴ユーザーを選択する
    driver.find_element(:xpath, select_selector[:select_user]).click
    # カテゴリURLを取得する
    category_url_arr = []
    category_url_arr = get_category_url()

    # カテゴリページを開く
    # begin
    @genre_id_list = [] # クロール中にジャンルidを保持しておいて同じidにアクセスしようとしたら処理を飛ばす
    category_url_arr.each do |category_url|

      # カテゴリではなくトップページならば飛ばす
      if category_url === 'https://www.netflix.com/browse'
        next
      end

      open_new_tab(driver)
      driver.get(category_url)

      # ジャンルをクリックする（クリックしておかないと値を取得できない）
      driver.find_element(:css, '#appMountPoint > div > div > div.pinning-header > div > div.sub-header > div:nth-child(2) > div > div > div.aro-genre-details > div.subgenres > div > div').click

      # ジャンルにアクセスする
      genre_url_arr = get_genre_url()
      genre_url_arr.each do |genre_url|

        # クロール中に一度でも読み込んだジャンルidは処理を飛ばす
        genre_id = get_genre_id(genre_url)
        if @genre_id_list.include?(genre_id)
          next
        end
        @genre_id_list << genre_id
        open_new_tab(driver)
        driver.get(genre_url)

        # 映画を一覧表示に切り替える
        driver.find_element(:css, "#appMountPoint > div > div > div.pinning-header > div > div.sub-header > div:nth-child(2) > div > div > div.aro-genre-details > div > div.aro-grid-toggle").click

        # 並び順を変えるボタンをクリックする
        driver.find_element(:css, "#appMountPoint > div > div > div.pinning-header > div > div.sub-header > div:nth-child(2) > div > div > div.aro-genre-details > div > div.aro-grid-toggle > div.sortGallery > div > div").click

        # 公開年でソートするソートするボタンをクリックする
        driver.find_element(:css, "#appMountPoint > div > div > div.pinning-header > div > div.sub-header > div:nth-child(2) > div > div > div.aro-genre-details > div > div.aro-grid-toggle > div.sortGallery > div > div.sub-menu.theme-aro > ul > li:nth-child(2) > a").click

# flatba^ 20180116 コンテンツ情報取得のために一旦コメントアウト
        # infinite_scrollを追加して末端まで読み込む
        # infinit_scroll(driver, 3)

        # コンテンツ読み込み待ち（読み込みより先にクリックしてしまう）上記有効化までこれで。
        sleep 5
# flatba$

        # ジャンル内の映画一覧から各コンテンツページにアクセスする
        galleryContent_list = driver.find_element(:class, 'galleryContent').find_elements(:class, 'rowContainer')
        galleryContent_list.each do |contents|
          contents_list = contents.find_elements(:tag_name, 'a')
          contents_list.each do |content|
            content_link = content.attribute('href')
            content_id = content_link[content_link.index('watch/') + ('watch/'.length)..content_link.index('?trackId')-1]
            puts content_url = "https://www.netflix.com/title/" + content_id

            # ページを開く
            open_new_tab(driver)
            driver.get(content_url)
            sleep 1
            close_new_tab(driver)
            sleep 1

          end
        end

      end

      close_new_tab(driver)
      sleep 1
    end

    @genre_id_list.clear

    # rescue RuntimeError => e
    #   print e.message
    #   $browser.close
    # rescue => e
    #   print e.message + "\n"
    # end
  end

end
