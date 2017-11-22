import PropTypes from 'prop-types';
import React from 'react';

import Map from '../components/Map';
import Search from '../components/Search';
import Realtime from '../components/Realtime';
import Socket from '../Socket';

export default class Home extends React.Component {
  static propTypes = {
    latitude: PropTypes.number.isRequired,
    longitude: PropTypes.number.isRequired
  };

  /**
   * @param props - Comes from your rails view.
   */
  constructor(props) {
    super(props);

    this.state = {};
    this.socket = new Socket();
    this.socket.setupSubscription(data => {
      console.log(data);
    });
  }

  render() {
    return (
      <div className="home_container">
        <img src="logo.svg" alt="WatsPoppin logo" id="logo" />

        <section className="map_container">
          <Map
            className="map"
            initialLat={this.props.latitude}
            initialLng={this.props.longitude}
          />
        </section>
        <section className="realtime_container">
          <h1>Hello Tweets</h1>

          <Search className="search" />

          <section className="stories_container">
            <Realtime />
          </section>
        </section>
      </div>
    );
  }
}
