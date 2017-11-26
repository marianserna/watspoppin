namespace :watspoppin do
  desc "Removes old tweets"
  task remove_old_tweets: :environment do
    Story.remove_old_tweets
  end
end
