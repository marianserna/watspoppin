import PropTypes from 'prop-types';
import React from 'react';

import axios from 'axios';
import Annyang from 'annyang';

import Map from '../components/Map';
import Search from '../components/Search';
import Realtime from '../components/Realtime';
import Socket from '../Socket';

export default class Home extends React.Component {
  static propTypes = {
    latitude: PropTypes.number.isRequired,
    longitude: PropTypes.number.isRequired,
    stories: PropTypes.array.isRequired,
    trending_hashtags: PropTypes.array.isRequired,
    user: PropTypes.object
  };

  /**
   * @param props - Comes from your rails view.
   */
  constructor(props) {
    super(props);

    this.state = {
      chrome: window.chrome,
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
      stories: props.stories,
      current_view: 'list'
    };

    this.socket = new Socket();
    this.socket.setupSubscription(
      (data) => {
        this.setState({ stories: [data, ...this.state.stories] });
      },
      this.state.currentPosition.latitude,
      this.state.currentPosition.longitude
    );
  }

  componentDidMount() {
    this.socket.update(this.state.currentPosition.latitude, this.state.currentPosition.longitude);

    if (this.state.chrome) {
      Annyang.addCommands({
        'search (for) :hashtag in *location': (hashtag, location) => {
          console.log(hashtag, location);

          const geo = new window.google.maps.Geocoder();
          geo.geocode({ address: location }, (results, status) => {
            if (status === window.google.maps.GeocoderStatus.OK) {
              const first_result = results[0];
              const result_location = first_result.geometry.location;

              this.search(hashtag, result_location.lat(), result_location.lng());

              if (window.speechSynthesis) {
                const talk = new SpeechSynthesisUtterance(`Searching for ${hashtag} in ${location}`);
                window.speechSynthesis.speak(talk);
              }
            }
          });
        }
      });
      Annyang.start();
    }
  }

  updateCurrentPosition = (lat, lng) => {
    this.setState({
      currentPosition: {
        latitude: lat,
        longitude: lng
      }
    });
  };

  updateViewport = (viewport) => {
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
      .then((response) => {
        this.setState({ stories: response.data });
      })
      .catch((error) => {
        console.log(error);
      });

    this.socket.subscription.perform('stop_realtime', {});
  };

  render() {
    return (
      <div className="home_container">
        <img src="logo.svg" alt="WatsPoppin logo" id="logo" />

        <div className="toggles">
          {this.state.current_view === 'list' ? (
            <button
              onClick={(e) => {
                e.preventDefault(e);
                this.setState({ current_view: 'map' });
                window.dispatchEvent(new Event('resize'));
              }}
            >
              MAP
            </button>
          ) : (
            <button
              onClick={(e) => {
                e.preventDefault(e);
                this.setState({ current_view: 'list' });
              }}
            >
              LIST
            </button>
          )}
        </div>

        <section
          className={`map_container ${this.state.mapExpanded ? 'map_expanded' : ''} ${
            this.state.current_view === 'map' ? 'active' : ''
          }`}
        >
          <button
            className="expand"
            onClick={(e) => {
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
            user={this.props.user}
          />
        </section>

        <section
          className={`realtime_container ${this.state.mapExpanded ? 'map_expanded' : ''} ${
            this.state.current_view === 'list' ? 'active' : ''
          }`}
        >
          <Search
            className="search"
            search={this.search}
            currentPosition={this.state.currentPosition}
          />

          {this.state.chrome ? (
            <p className="voice_search">
              <span>
                For voice search pronounce "Search <strong>HASHTAG</strong> in{' '}
                <strong>LOCATION</strong>"
              </span>
            </p>
          ) : (
            ''
          )}

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
