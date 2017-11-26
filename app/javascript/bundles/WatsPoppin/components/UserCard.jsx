import React from 'react';
import PropTypes from 'prop-types';

export default class UserCard extends React.Component {
  static propTypes = {
    user: PropTypes.object
  };

  render() {
    const { user } = this.props;

    if (!user) {
      return (
        <figure>
          <img src="/mario.jpg" alt="super mario" />
          <figcaption>You're here!!</figcaption>
        </figure>
      );
    }
    const image_url = user.image.thumb.url;

    return (
      <figure>
        <img src={image_url || '/mario.jpg'} alt={user.name} />
        <figcaption>{user.name}</figcaption>
      </figure>
    );
  }
}
