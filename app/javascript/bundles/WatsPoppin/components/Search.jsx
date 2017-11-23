import React from 'react';
import PropTypes from 'prop-types';
import Geosuggest from 'react-geosuggest';

export default class Search extends React.Component {
  static propTypes = {
    search: PropTypes.func.isRequired,
    currentPosition: PropTypes.object.isRequired
  };

  constructor(props) {
    super(props);

    this.state = {
      latitude: this.props.currentPosition.latitude,
      longitude: this.props.currentPosition.longitude
    };
  }

  handleSubmit = e => {
    e.preventDefault();
    this.props.search(
      this.hashtag.value,
      this.state.latitude,
      this.state.longitude
    );
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
          <Geosuggest
            onSuggestSelect={suggest => {
              this.setState({
                latitude: suggest.location.lat,
                longitude: suggest.location.lng
              });
            }}
          />
          <button type="submit">SERCH</button>
        </form>
      </div>
    );
  }
}
