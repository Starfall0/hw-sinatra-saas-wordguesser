# frozen_string_literal: true

require 'spec_helper'
require 'wordguesser_game'

describe WordGuesserGame do
  # helper function: make several guesses
  def guess_several_letters(game, letters)
    letters.chars do |letter|
      game.guess(letter)
    end
  end

  describe 'new' do # , :pending => true do
    it 'takes a parameter and returns a WordGuesserGame object' do
      @game = WordGuesserGame.new('glorp')
      expect(@game).to be_an_instance_of(WordGuesserGame)
      expect(@game.word).to eq('glorp')
      expect(@game.guesses).to eq('')
      expect(@game.wrong_guesses).to eq('')
    end
  end

  describe 'guessing' do # , :pending => true do
    context 'correctly' do
      before :each do
        @game = WordGuesserGame.new('garply')
        @valid = @game.guess('a')
      end
      it 'changes correct guess list' do # , :pending => true do
        expect(@game.guesses).to eq('a')
        expect(@game.wrong_guesses).to eq('')
      end
      it 'returns true' do # , :pending => true do
        expect(@valid).not_to be false
      end
    end
    context 'incorrectly' do
      before :each do
        @game = WordGuesserGame.new('garply')
        @valid = @game.guess('z')
      end
      it 'changes wrong guess list' do # , :pending => true do
        expect(@game.guesses).to eq('')
        expect(@game.wrong_guesses).to eq('z')
      end
      it 'returns true' do # , :pending => true do
        expect(@valid).not_to be false
      end
    end
    context 'same letter repeatedly' do
      before :each do
        @game = WordGuesserGame.new('garply')
        guess_several_letters(@game, 'aq')
      end
      it 'does not change correct guess list' do # , :pending => true do
        @game.guess('a')
        expect(@game.guesses).to eq('a')
      end
      it 'does not change wrong guess list' do # , :pending => true do
        @game.guess('q')
        expect(@game.wrong_guesses).to eq('q')
      end
      it 'returns false' do # , :pending => true do
        expect(@game.guess('a')).to be false
        expect(@game.guess('q')).to be false
      end
      it 'is case insensitive' do # , :pending => true do
        expect(@game.guess('A')).to be false
        expect(@game.guess('Q')).to be false
        expect(@game.guesses).not_to include('A')
        expect(@game.wrong_guesses).not_to include('Q')
      end
    end
    context 'invalid' do
      before :each do
        @game = WordGuesserGame.new('foobar')
      end
      it 'throws an error when empty' do # , :pending => true do
        expect { @game.guess('') }.to raise_error(ArgumentError)
      end
      it 'throws an error when not a letter' do # , :pending => true do
        expect { @game.guess('%') }.to raise_error(ArgumentError)
      end
      it 'throws an error when nil' do # , :pending => true do
        expect { @game.guess(nil) }.to raise_error(ArgumentError)
      end
    end
  end

  describe 'displayed word with guesses' do # , :pending => true do
    before :each do
      @game = WordGuesserGame.new('banana')
    end
    # for a given set of guesses, what should the word look like?
    @test_cases = {
      'bn' => 'b-n-n-',
      'def' => '------',
      'ban' => 'banana'
    }
    @test_cases.each_pair do |guesses, displayed|
      it "should be '#{displayed}' when guesses are '#{guesses}'" do
        guess_several_letters(@game, guesses)
        expect(@game.word_with_guesses).to eq(displayed)
      end
    end
  end

  describe 'game status' do
    before :each do
      @game = WordGuesserGame.new('dog')
    end
    it 'should be win when all letters guessed' do # , :pending => true do
      guess_several_letters(@game, 'ogd')
      expect(@game.check_win_or_lose).to eq(:win)
    end
    it 'should be lose after 7 incorrect guesses' do # , :pending => true do
      guess_several_letters(@game, 'tuvwxyz')
      expect(@game.check_win_or_lose).to eq(:lose)
    end
    it 'should continue play if neither win nor lose' do # , :pending => true do
      guess_several_letters(@game, 'do')
      expect(@game.check_win_or_lose).to eq(:play)
    end
  end
end
