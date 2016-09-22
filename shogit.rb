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
    end

    def gote(position, piece, *args)
    end

    def show(index)
    end

    def convert(word)
      WORDS[word] if WORDS.key?(word)
    end

    def method_missing(method, *args)
      convert(method) || super
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

    def path
      ::File.join(repo.workdir, relative_path)
    end

    def content
      ::File.open(path, "r") do |f|
        return f.read
      end
    end
  end
end
