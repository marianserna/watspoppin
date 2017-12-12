import React from 'react';
import PropTypes from 'prop-types';

import Linkify from 'react-linkify';
import mojs from 'mo-js';

class Heart extends mojs.CustomShape {
  getShape = () =>
    '<path d="M73.6170213,0 C64.4680851,0 56.5957447,5.53191489 51.7021277,13.8297872 C50.8510638,15.3191489 48.9361702,15.3191489 48.0851064,13.8297872 C43.4042553,5.53191489 35.3191489,0 26.1702128,0 C11.9148936,0 0,14.0425532 0,31.2765957 C0,48.0851064 14.893617,77.8723404 47.6595745,99.3617021 C49.1489362,100.212766 50.8510638,100.212766 52.1276596,99.3617021 C83.8297872,78.5106383 99.787234,48.2978723 99.787234,31.2765957 C100,14.0425532 88.0851064,0 73.6170213,0 L73.6170213,0 Z"></path>';
}

mojs.addShape('heart', Heart);

export default class StoryCard extends React.PureComponent {
  static propTypes = {
    user: PropTypes.shape({
      id: PropTypes.number
    }),
    story: PropTypes.shape({
      id: PropTypes.number,
      content: PropTypes.string,
      image: PropTypes.shape({
        thumb: PropTypes.shape({
          url: PropTypes.string
        })
      })
    }).isRequired,
    liked_story_ids: PropTypes.array.isRequired,
    likeStory: PropTypes.func.isRequired
  };

  static defaultProps = {
    user: null
  };

  like = (e) => {
    e.stopPropagation();
    e.preventDefault();

    fetch(`/stories/${this.props.story.id}/likes.json`, {
      method: 'post',
      headers: new Headers({
        'Content-Type': 'application/json'
      }),
      credentials: 'include'
    });

    this.props.likeStory(this.props.story.id);
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
        {this.props.user && (
          <div className="heart-container">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 100 100"
              className={`${this.props.liked_story_ids.includes(story.id) ? 'hearted' : ''} heart`}
              onClick={e => this.like(e)}
            >
              <g>
                <path d="M73.6170213,0 C64.4680851,0 56.5957447,5.53191489 51.7021277,13.8297872 C50.8510638,15.3191489 48.9361702,15.3191489 48.0851064,13.8297872 C43.4042553,5.53191489 35.3191489,0 26.1702128,0 C11.9148936,0 0,14.0425532 0,31.2765957 C0,48.0851064 14.893617,77.8723404 47.6595745,99.3617021 C49.1489362,100.212766 50.8510638,100.212766 52.1276596,99.3617021 C83.8297872,78.5106383 99.787234,48.2978723 99.787234,31.2765957 C100,14.0425532 88.0851064,0 73.6170213,0 L73.6170213,0 Z" />
              </g>
            </svg>
          </div>
        )}
      </figure>
    );
  }
}
