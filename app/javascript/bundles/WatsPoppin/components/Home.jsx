import PropTypes from 'prop-types';
import React from 'react';

import Map from '../components/Map';
import Search from '../components/Search';
import Realtime from '../components/Realtime';
import Socket from '../Socket';

export default class Home extends React.Component {
  static propTypes = {
    latitude: PropTypes.number.isRequired,
    longitude: PropTypes.number.isRequired,
    stories: PropTypes.array.isRequired
  };

  /**
   * @param props - Comes from your rails view.
   */
  constructor(props) {
    super(props);

    this.state = {
      currentPosition: {
        latitude: props.latitude,
        longitude: props.longitude
      },
      stories: props.stories
    };
    this.socket = new Socket();
    this.socket.setupSubscription(
      data => {
        this.setState({ stories: [data, ...this.state.stories] });
      },
      this.state.currentPosition.latitude,
      this.state.currentPosition.longitude
    );
  }

  componentDidMount() {
    this.socket.update(
      this.state.currentPosition.latitude,
      this.state.currentPosition.longitude
    );
  }

  updateCurrentPosition = (lat, lng) => {
    this.setState({
      currentPosition: {
        latitude: lat,
        longitude: lng
      }
    });
  };

  render() {
    return (
      <div className="home_container">
        <img src="logo.svg" alt="WatsPoppin logo" id="logo" />

        <section className="map_container">
          <Map
            className="map"
            currentPosition={this.state.currentPosition}
            updateCurrentPosition={this.updateCurrentPosition}
            stories={this.state.stories}
          />
        </section>
        <section className="realtime_container">
          <h1>Hello Tweets</h1>

          <Search className="search" />

          <section className="stories_container">
            <Realtime stories={this.state.stories} />
          </section>
        </section>
      </div>
    );
  }
}
