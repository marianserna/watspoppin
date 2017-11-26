import React from 'react';
import PropTypes from 'prop-types';

import Linkify from 'react-linkify';

export default class StoryCard extends React.PureComponent {
  static propTypes = {
    story: PropTypes.shape({
      content: PropTypes.string,
      image: PropTypes.shape({
        thumb: PropTypes.shape({
          url: PropTypes.string
        })
      })
    }).isRequired
  };

  render() {
    const { story } = this.props;
    const imageUrl = story.image.thumb.url;

    return (
      <figure>
        <img
          className={imageUrl ? 'user_img' : 'default_img'}
          src={imageUrl || '/twitter-logo.svg'}
          alt={story.content}
        />
        <Linkify>
          <figcaption>{story.content}</figcaption>
        </Linkify>
      </figure>
    );
  }
}
