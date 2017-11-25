import React from 'react';
import PropTypes from 'prop-types';

export default class UserCard extends React.Component {
  static propTypes = {
    user: PropTypes.object
  };

  render() {
    if (!this.props.user) {
      return (
        <figure>
          <img src="/mario.jpg" alt="super mario" />
          <figcaption>You're here!!</figcaption>
        </figure>
      );
    }
    return (
      <figure>
        <img
          src="https://assets.vogue.com/photos/5891c8b097a3db337a24c8f7/master/pass/llamas-and-haircuts-prince-harry1.jpg"
          alt={this.props.user.name}
        />
        <figcaption>You are here</figcaption>
      </figure>
    );
  }
}
