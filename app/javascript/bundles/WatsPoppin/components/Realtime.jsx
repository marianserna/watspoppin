import React from 'react';
import PropTypes from 'prop-types';

import Linkify from 'react-linkify';

export default class Realtime extends React.Component {
  static propTypes = {
    stories: PropTypes.array.isRequired,
    trending_hashtags: PropTypes.array.isRequired,
    search: PropTypes.func.isRequired
  };

  constructor(props) {
    super(props);

    this.state = {
      collapsed: true
    };
  }

  triggerSearch = (e, trend) => {
    e.preventDefault();
    e.stopPropagation();
    this.props.search(trend);
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
              <p className="handle">{story.handle}</p>
              <Linkify>
                <p>{story.content.substring(0, 600)}...</p>
              </Linkify>
            </div>
          ))}
        </div>

        <div
          className={`trends ${this.state.collapsed ? 'collapsed' : ''}`}
          onClick={e => {
            e.preventDefault();
            this.setState({
              collapsed: !this.state.collapsed
            });
          }}
        >
          <p>TRENDING</p>

          <section className="trending_hashtags">
            <ul>
              {this.props.trending_hashtags.map(trend => (
                <li key={trend}>
                  <a
                    className="trend_link"
                    href="#"
                    onClick={e => this.triggerSearch(e, trend)}
                  >
                    {trend}
                  </a>
                </li>
              ))}
            </ul>
          </section>
        </div>
      </div>
    );
  }
}
