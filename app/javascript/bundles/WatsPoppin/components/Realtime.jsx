import React from 'react';
import PropTypes from 'prop-types';

export default class Realtime extends React.Component {
  static propTypes = {
    stories: PropTypes.array.isRequired
  };

  render() {
    return (
      <div>
        <div className="stories">
          {this.props.stories.map(story => (
            <div key={story.id} className="realtime_story">
              <img
                className={story.image.thumb.url ? 'user_img' : 'default_img'}
                src={
                  story.image.thumb.url
                    ? story.image.thumb.url
                    : '/twitter-logo.svg'
                }
                alt={story.content}
              />
              <p>{story.content.substring(0, 600)}...</p>
            </div>
          ))}
        </div>

        <div className="trends">
          <p>TRENDING</p>
        </div>
      </div>
    );
  }
}
