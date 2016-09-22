require 'rugged'

module Shogit
  module Console
    WORDS = {
      gyoku: "玉",
      hisha: "飛",
      kaku: "角",
      kin: "金",
      gin: "銀",
      keima: "桂",
      kyousha: "香",
      fu: "歩",
      ryu: "竜",
      uma: "馬",
      narigin: "成銀",
      narikei: "成桂",
      narikyo: "成香",
      tokin: "と",

      utsu: "打",
      naru: "成",
      funari: "不成",

      agaru: "上",
      hiku: "引",
      yoru: "寄",
      sugu: "直",
      migi: "右",
      hidari: "左"
    }

    def sente(position, piece, *args)
      chakushu("▲", position, piece, *args)
    end

    def gote(position, piece, *args)
      chakushu("△ ", position, piece, *args)
    end

    def show(index)
    end

    def convert(word)
      WORDS[word] if WORDS.key?(word)
    end

    def method_missing(method, *args)
      convert(method) || super
    end

    def chakushu(mark, position, piece, *args)
      suji = position / 10
      dan = ["","一","二","三","四","五","六","七","八","九"].fetch(position % 10)
      m = "#{mark}#{suji}#{dan}#{piece}#{args.join('')}".tap do |message|
        save(message)
      end
      formatted_move(m, count)
    end

    def formatted_move(message, index)
      "#{index} #{message}"
    end

    def count
      file.count_lines
    end

    def save(message)
      file.add(message)
      git.add_and_commit(file, message)
    end

    def git
      @git ||= Git.new
    end

    def file
      @file ||= File.new
    end
  end

  class Git
    def initialize
      path = './data/hirate'
      Rugged::Repository.init_at(path)
      @repo = Rugged::Repository.discover(path)
    end

    def repo
      @repo
    end

    def git_user
      { :email => "testuser@github.com", :name => 'Test Author' }
    end

    def add_and_commit(file, message)
      oid = repo.write(file.content, :blob)
      index = repo.index
      index.read_tree(repo.head.target.tree) rescue nil
      index.add(:path => file.relative_path, :oid => oid, :mode => 0100644)
      index.write
      commit(index, message)
    end

    def commit(index, message)
      options = {}
      options[:tree] = index.write_tree(repo)
      options[:author]    = git_user.merge(:time => Time.now)
      options[:committer] = git_user.merge(:time => Time.now)
      options[:message] ||= message
      options[:parents] = repo.empty? ? [] : [ repo.head.target ].compact
      options[:update_ref] = 'HEAD'

      Rugged::Commit.create(repo, options)
    end
  end

  class File
    def initialize
      @repo = Git.new.repo
    end

    def relative_path
      'kifu.txt'
    end

    def repo
      @repo
    end

    def touch
      ::File.open(path, "w") do |f|
      end
    end

    def add(message)
      ::File.open(path, "a") do |f|
        f.puts message
      end
    end

    def path
      ::File.join(repo.workdir, relative_path)
    end

    def content
      ::File.open(path, "r") do |f|
        return f.read
      end
    end

    def lines
      content.split("\n")
    end

    def count_lines
      lines.count
    end
  end
end
