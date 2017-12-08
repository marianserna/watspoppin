import React from 'react';
import PropTypes from 'prop-types';
import Geosuggest from 'react-geosuggest';

export default class Search extends React.Component {
  static propTypes = {
    search: PropTypes.func.isRequired,
    currentPosition: PropTypes.shape({
      latitude: PropTypes.number.isRequired,
      longitude: PropTypes.number.isRequired
    }).isRequired
  };

  constructor(props) {
    super(props);

    this.state = {
      latitude: this.props.currentPosition.latitude,
      longitude: this.props.currentPosition.longitude
    };
  }

  handleSubmit = (e) => {
    e.preventDefault();
    this.props.search(this.hashtag.value, this.state.latitude, this.state.longitude);
  };

  render() {
    return (
      <div>
        <form className="search" onSubmit={e => this.handleSubmit(e)}>
          <input
            type="text"
            className="hashtag"
            placeholder="HASHTAG"
            ref={(input) => {
              this.hashtag = input;
            }}
          />
          <Geosuggest
            className="geosuggest"
            onSuggestSelect={(suggest) => {
              this.setState({
                latitude: suggest.location.lat,
                longitude: suggest.location.lng
              });
            }}
          />
          <button type="submit" className="search">
            SEARCH
          </button>
        </form>
      </div>
    );
  }
}
