require 'json'
require 'rest-client'

class GamesController < ApplicationController
  ALPHABET = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']

  def new
    @letters = []
    10.times do
      @letters << ALPHABET.sample
    end
    return @letters
  end

  def score
    @letters = params[:letters].split
    @word = params[:word]
    @included = included?(@word, @letters)
    @answer = ""
    # check if the word is part of the original grid
    if @included
      if english_word(@word)
        @score = compute_score(@word)
        @answer = "your score is #{@score} points"
      else
        @answer = "not an english word"
      end
    else
      @answer =  "not in the grid"
      # check if is an english word through the API
    end
    return @answer
  end

  private

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word(word)
    response = RestClient.get "https://wagon-dictionary.herokuapp.com/#{word}"
    puts repos = JSON.parse(response)
    repos["found"]
  end

  def compute_score(word)
    return word.length * 3
  end
end
