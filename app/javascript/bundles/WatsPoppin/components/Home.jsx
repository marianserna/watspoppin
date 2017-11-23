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
    stories: PropTypes.array.isRequired
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

  search = (hashtag, latitude, longitude) => {
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

        <section className="map_container">
          <button className="expand">FULL SCREEN</button>

          <Map
            className="map"
            viewport={this.state.viewport}
            currentPosition={this.state.currentPosition}
            updateCurrentPosition={this.updateCurrentPosition}
            updateViewport={this.updateViewport}
            stories={this.state.stories}
          />

          <nav>
            <section className="left-nav">
              <a href="#">
                <img
                  src="home-icon.svg"
                  alt="home icon"
                  className="home-icon"
                />
              </a>
            </section>

            <section className="middle-nav">
              <a href="#">
                <img
                  src="pencil-icon.svg"
                  alt="pencil icon"
                  className="pencil-icon"
                />
              </a>
            </section>

            <section className="right-nav">
              <a href="#">
                <div className="login">LOGIN</div>
              </a>
              <a href="#">
                <div className="signup">SIGN UP</div>
              </a>
            </section>
          </nav>
        </section>

        <section className="realtime_container">
          <Search
            className="search"
            search={this.search}
            currentPosition={this.state.currentPosition}
          />

          <Realtime className="realtime" stories={this.state.stories} />
        </section>
      </div>
    );
  }
}
