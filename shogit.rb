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
end
