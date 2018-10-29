require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = (0..10).map { ('A'..'Z').to_a[rand(26)] }
  end

  def score
    # raise
    @attempt = params[:word]
    if english_word?(@attempt) && found_in_grid?(@attempt, params[:letters])
      @answer = "Yes #{@attempt} is english word and is in the grid"
    elsif english_word?(@attempt) && !found_in_grid?(@attempt, params[:letters])
      @answer = "This word is not available from the letters available"
    else
      @answer = "No #{@attempt} is not English word and not in the grid"
    end
  end

  def english_word?(attempt)
    result = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{attempt}").read)
    result["found"]
  end

  def found_in_grid?(attempt, grid)
    # if the attemnpt is included in grid, return true, if not return false
    grid = grid.split(' ')
    attempt = attempt.upcase
    attempt_letters = attempt.split('')
    attempt_letters.all? do |letter|
      attempt.count(letter) <= grid.count(letter)
    end
  end
end


