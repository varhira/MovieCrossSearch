# coding: utf-8
require 'sqlite3'

#
# 保存処理
#
class SaveDBTask
  #
  # DB生成
  # CREATE TABLE IF NOT EXISTS をすると作成済みのテーブルを作ろうとするエラーを防げます。
  # 回す前にバックアップを生成して、更新が終わったらバックアップは削除する処理でも良いかも
  # ある程度進んだらActiveRecord使ってみたい
  #

  # attr_reader :db


# initialize
  def initialize(site_name)

    # 出力先ディレクトリの有無の確認して無ければ作成する
    unless File.directory?("./db") || File.directory?("./output") || File.directory?("./output/screenshot")
      Dir::mkdir("./db")
      Dir::mkdir("./output")
      Dir::mkdir("./output/screenshot")
    end

    # movie_master_table（ムービーテーブル）の生成
    output_directory = 'db/' + site_name + '/' + 'movie_master' + '.db'

    unless File.directory?("./db/" + site_name)
      Dir::mkdir("./db/" + site_name)
    end

    @db = SQLite3::Database.new(output_directory)
    @db.execute 'CREATE TABLE IF NOT EXISTS movie_master (
      thumbnail varchar(500),
      title varchar(200),
      original_title varchar(200),
      release_year varchar(200),
      running_time varchar(200),
      summary varchar(200)
      );'

    # cast_table（ジャンルテーブル）の生成
    output_directory = 'db/' + site_name + '/' + 'cast' + '.db'
    @db = SQLite3::Database.new(output_directory)
    @db.execute(
      'CREATE TABLE IF NOT EXISTS genre_master (
        cast varchar(200)
      );'
    )

    # director_tale（監督テーブル）の生成
    output_directory = 'db/' + site_name + '/' + 'director' + '.db'
    @db = SQLite3::Database.new(output_directory)
    @db.execute(
      'CREATE TABLE IF NOT EXISTS director (
        director varchar(200)
      );'
    )

    # director_tale（監督テーブル）の生成
    output_directory = 'db/' + site_name + '/' + 'director' + '.db'
    @db = SQLite3::Database.new(output_directory)
    @db.execute(
      'CREATE TABLE IF NOT EXISTS director (
        movie_id varchar(200),
        genre_id varchar(200)
      );'
    )

    # movie_genre_table（映画とジャンルの紐付け）の生成（中間テーブル）
    output_directory = 'db/' + site_name + '/' + 'movie_genre' + '.db'
    @db = SQLite3::Database.new(output_directory)
    @db.execute(
      'CREATE TABLE IF NOT EXISTS movie_genre_master (
        movie_id varchar(200),
        genre_id varchar(200)
      );'
    )

    # movie_director_table（映画と監督の紐付け）の生成（中間テーブル）
    output_directory = 'db/' + site_name + '/' + 'movie_director' + '.db'
    @db = SQLite3::Database.new(output_directory)
    @db.execute(
      'CREATE TABLE IF NOT EXISTS movie_director_master (
        movie varchar(200),
        director varchar(200)
      );'
    )

    # movie_cast_table（映画と監督の紐付け）の生成（中間テーブル）
    output_directory = 'db/' + site_name + '/' + 'movie_cast' + '.db'
    @db = SQLite3::Database.new(output_directory)
    @db.execute(
      'CREATE TABLE IF NOT EXISTS movie_cast_master (
        movie varchar(200),
        cast varchar(200)
      );'
    )


# 中間テーブル

  # movie_genre_table（映画とジャンルの紐付け）の生成（中間テーブル）
  output_directory = 'db/' + site_name + '/' + 'movie_genre' + '.db'
  @db = SQLite3::Database.new(output_directory)
  @db.execute(
    'CREATE TABLE IF NOT EXISTS movie_genre_master (
      movie_id varchar(200),
      genre_id varchar(200)
    );'
  )

  # movie_director_table（映画と監督の紐付け）の生成（中間テーブル）
  output_directory = 'db/' + site_name + '/' + 'movie_director' + '.db'
  @db = SQLite3::Database.new(output_directory)
  @db.execute(
    'CREATE TABLE IF NOT EXISTS movie_director_master (
      movie varchar(200),
      director varchar(200)
    );'
  )

  # movie_cast_table（映画と監督の紐付け）の生成（中間テーブル）
  output_directory = 'db/' + site_name + '/' + 'movie_cast' + '.db'
  @db = SQLite3::Database.new(output_directory)
  @db.execute(
    'CREATE TABLE IF NOT EXISTS movie_cast_master (
      movie varchar(200),
      cast varchar(200)
    );'
  )
#

  end
#


#
# 映画コンテンツ / ジャンル / 監督 / キャスト CRUDでまとめてみる
#
# 映画コンテンツテーブル

  # 映画コンテンツの追加
  def create_contents_DB(contents)
    @db.execute "INSERT INTO movie_master (thumbnail,title,original_title,release_year,genres,running_time,director,summary) values ('#{contents.thumbnail}','#{contents.title}','#{contents.original_title}','#{contents.release_year}','#{contents.genres}','#{contents.running_time}','#{contents.director}','#{contents.summary}');"
  end

  # 映画コンテンツの取得
  def read_movie_master_item(column_name, item_name)
    @db.execute "SELECT * FROM movie_master WHERE column = 'column_name';, '#{column_name}','#{item_name}'"
  end

  # 映画コンテンツの更新
  # レコード探索して、idなどが合致していたら？
  # SELECT * FROM movie_master;
  # @db.execute "SELECT * FROM customer WHERE title=(title);,'#{contents.title}'"
  def update_contents_DB(contents)
    @db.execute "UPDATE movie_master SET title=(title) WHERE title=(title); ,'#{contents.title}'"
  end

  # 映画コンテンツの削除
  def delete_contents_DB(contents)
    @db.execute "DELETE  FROM movie_master WHERE title=(title);,'#{contents.title}'"
  end
#

# ジャンルテーブル
  # ジャンルの追加
  def create_genre_DB(genres)
    @db.execute "insert into genre_master (genres) values('#{contents.genres}')"
  end

  # ジャンルの取得
  def read_genre_master_item(column_name, item_name)
    @db.execute "SELECT * FROM genre_master WHERE column = 'column_name';, '#{column_name}','#{item_name}'"
  end

  # ジャンルの更新
  def update_genre_DB(genres)
    @db.execute "UPDATE genre_master SET genres=(genres) WHERE title=(title); ,'#{genres.name}'"
  end

  # ジャンルの削除
  def delete_genre_DB(genres)
    @db.execute "DELETE  FROM genre_master WHERE genre=(genre);,'#{genres.name}'"
  end

    # ジャンルの追加
  def create_genre_DB(genres)
    @db.execute "insert into genre_master (genres) values('#{contents.genres}')"
  end

  # ジャンルの取得
  def read_genre_master_item(column_name, item_name)
    @db.execute "SELECT * FROM genre_master WHERE column = 'column_name';, '#{column_name}','#{item_name}'"
  end

  # ジャンルの更新
  def update_genre_DB(genres)
    @db.execute "UPDATE genre_master SET genres=(genres) WHERE title=(title); ,'#{genres.name}'"
  end

  # ジャンルの削除
  def delete_genre_DB(genres)
    @db.execute "DELETE  FROM genre_master WHERE genre=(genre);,'#{genres.name}'"
  end
#

# 監督テーブル
  # 監督の追加
  def create_director_DB(director)
    @db.execute "insert into director_master (genres) values('#{director}')"
  end

  # 監督の取得
  def read_director_master_item(column_name, item_name)
    @db.execute "SELECT * FROM director_master WHERE column = 'column_name';, '#{column_name}','#{item_name}'"
  end

  # 監督の更新
  def update_director_DB(director)
    @db.execute "UPDATE director_master SET director=(director) WHERE title=(title); ,'#{director}'"
  end

  # 監督の削除
  def delete_genre_DB(director)
    @db.execute "DELETE  FROM director_master WHERE director=(director);,'#{director}'"
  end
#

# キャストテーブル
  # キャストの追加
  def create_cast_DB(cast)
    @db.execute "insert into cast_master (cast) values('#{cast}')"
  end

  # キャストの取得
  def read_cast_master_item(column_name, item_name)
    @db.execute "SELECT * FROM cast_master WHERE column = 'column_name';, '#{column_name}','#{item_name}'"
  end

  # キャストの更新
  def update_cast_DB(cast)
    @db.execute "UPDATE cast_master SET director=(director) WHERE title=(title); ,'#{cast}'"
  end

  # キャストの削除
  def delete_cast_DB(cast)
    @db.execute "DELETE  FROM cast_master WHERE cast=(cast);,'#{cast}'"
  end
#



  #
  # データベースの編集終了
  #

  def close_DB_task
    @db.close
  end

end
