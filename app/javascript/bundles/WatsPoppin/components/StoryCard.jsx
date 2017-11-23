import React from 'react';
import PropTypes from 'prop-types';

export default class StoryCard extends React.Component {
  static propTypes = {
    story: PropTypes.object.isRequired
  };

  render() {
    const { story } = this.props;
    const image_url = story.image.thumb.url;

    return (
      <figure>
        <img
          className={image_url ? 'user_img' : 'default_img'}
          src={image_url ? image_url : '/twitter-logo.svg'}
          alt={story.id}
        />
        <figcaption>{story.content}</figcaption>
      </figure>
    );
  }
}
