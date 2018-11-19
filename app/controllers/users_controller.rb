class UsersController < ApplicationController
  def index
    @users = [
      User.new(
        id: 1,
        name: 'Vadim',
        username: 'installero',
        avatar_url: 'https://s00.yaplakal.com/pics/pics_original/4/6/4/10101464.jpg'
      ),
      User.new(
        id: 2,
        name: 'Misha',
        username: 'aristofun'
      )   
    ]
  end

  def new
  end

  def edit
  end

  def show
    @user = User.new(
                    name: 'Vadim',
                    username: 'installero',
                    avatar_url: 'https://s00.yaplakal.com/pics/pics_original/4/6/4/10101464.jpg'
    )

    @questions = [
      Question.new(text: 'How are you?', created_at: Date.parse('27.03.2016')),
      Question.new(text: 'How are you?', created_at: Date.parse('27.03.2016'))
    ]

    @new_question = Question.new
  end
end
