require 'spec_helper'

describe CommentsController do

  describe "GET 'create'" do
    it "returns http success" do
      get 'create'
      response.should be_success
    end
  end

  describe "GET 'destory'" do
    it "returns http success" do
      get 'destory'
      response.should be_success
    end
  end

end
