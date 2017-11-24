import PropTypes from 'prop-types';
import React from 'react';

import axios from 'axios';

import Map from '../components/Map';
import Search from '../components/Search';
import Realtime from '../components/Realtime';
import Socket from '../Socket';

export default class Home extends React.Component {
  static propTypes = {
    latitude: PropTypes.number.isRequired,
    longitude: PropTypes.number.isRequired,
    stories: PropTypes.array.isRequired,
    trending_hashtags: PropTypes.array.isRequired
  };

  /**
   * @param props - Comes from your rails view.
   */
  constructor(props) {
    super(props);

    this.state = {
      viewport: {
        latitude: props.latitude,
        longitude: props.longitude,
        zoom: 9
      },
      mapExpanded: false,
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

  updateViewport = viewport => {
    this.setState({
      viewport
    });
  };

  search = (hashtag, latitude = null, longitude = null) => {
    if (!latitude) {
      latitude = this.state.currentPosition.latitude;
    }

    if (!longitude) {
      longitude = this.state.currentPosition.longitude;
    }

    this.setState({
      viewport: {
        ...this.state.viewport,
        latitude,
        longitude
      }
    });

    axios
      .get('/stories/search', {
        params: {
          hashtag,
          latitude,
          longitude
        }
      })
      .then(response => {
        this.setState({ stories: response.data });
      })
      .catch(error => {
        console.log(error);
      });

    this.socket.unsubscribe();
  };

  render() {
    return (
      <div className="home_container">
        <img src="logo.svg" alt="WatsPoppin logo" id="logo" />

        <section
          className={`map_container ${
            this.state.mapExpanded ? 'map_expanded' : ''
          }`}
        >
          <button
            className="expand"
            onClick={e => {
              this.setState({ mapExpanded: !this.state.mapExpanded });

              window.dispatchEvent(new Event('resize'));
            }}
          >
            {this.state.mapExpanded ? 'COLLAPSE' : 'EXPAND'}
          </button>

          <Map
            className="map"
            viewport={this.state.viewport}
            currentPosition={this.state.currentPosition}
            updateCurrentPosition={this.updateCurrentPosition}
            updateViewport={this.updateViewport}
            stories={this.state.stories}
          />
        </section>

        <section
          className={`realtime_container ${
            this.state.mapExpanded ? 'map_expanded' : ''
          }`}
        >
          <Search
            className="search"
            search={this.search}
            currentPosition={this.state.currentPosition}
          />

          <Realtime
            className="realtime"
            stories={this.state.stories}
            trending_hashtags={this.props.trending_hashtags}
            search={this.search}
          />
        </section>
      </div>
    );
  }
}
