import React from 'react';
import PropTypes from 'prop-types';

export default class Search extends React.Component {
  static propTypes = {
    search: PropTypes.func.isRequired
  };

  handleSubmit = e => {
    e.preventDefault();
    this.props.search(this.hashtag.value, this.location.value);
  };

  render() {
    return (
      <div>
        <p>Find out what's going on!</p>
        <form onSubmit={e => this.handleSubmit(e)}>
          <label htmlFor="hashtag" />
          <input
            type="text"
            id="hashtag"
            placeholder="#hashtag"
            ref={input => (this.hashtag = input)}
          />
          <input
            type="text"
            id="location"
            placeholder="location"
            ref={input => (this.location = input)}
          />
          <button type="submit">SERCH</button>
        </form>
      </div>
    );
  }
}
