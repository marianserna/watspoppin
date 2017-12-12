require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe 'GET main' do
    it 'renders correctly and passes props to view' do
      # mocking with method stubs
      expect_any_instance_of(TwitterTrends).to receive(:trends).and_return(['#MooseOnTheLoose'])

      story = create(:story)

      get :main

      expect(response.status).to eq(200)
      expect(assigns(:props)).to eq({
        latitude: 43.653226,
        longitude: -79.383184,
        stories: [story],
        trending_hashtags: ["#MooseOnTheLoose"],
        user: nil,
        liked_story_ids: []
      })
    end
  end
end
