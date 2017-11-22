import React from 'react';
import PropTypes from 'prop-types';

export default class Realtime extends React.Component {
  static propTypes = {
    stories: PropTypes.array.isRequired
  };

  render() {
    return (
      <div>
        {this.props.stories.map(story => (
          <figure key={story.id} className="realtime_figure">
            <img src={story.image.thumb.url} alt={story.content} />
            <figcaption>{story.content.substring(0, 25)}...</figcaption>
          </figure>
        ))}
      </div>
    );
  }
}
