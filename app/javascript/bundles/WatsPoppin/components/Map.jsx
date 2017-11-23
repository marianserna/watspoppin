import React from 'react';
import PropTypes from 'prop-types';
import ReactMapGL, { Marker, Popup } from 'react-map-gl';
import Dimensions from 'react-dimensions';

import Pin from './Pin';
import UserCard from './UserCard';
import StoryCard from './StoryCard';

class Map extends React.Component {
  static propTypes = {
    currentPosition: PropTypes.object.isRequired,
    stories: PropTypes.array.isRequired
  };

  constructor(props) {
    super(props);

    this.state = {
      viewport: {
        latitude: props.currentPosition.latitude,
        longitude: props.currentPosition.longitude,
        zoom: 12
      },
      popupStatus: null,
      popupStory: null
    };

    // Needed because initial marker(using geocoder position) wasnt showing until scroll
    setTimeout(() => {
      this.setState({});
    }, 50);
  }

  getCurrentPosition = () => {
    window.navigator.geolocation.getCurrentPosition(position => {
      this.setState({
        viewport: {
          ...this.state.viewport,
          latitude: position.coords.latitude,
          longitude: position.coords.longitude
        }
      });
      this.props.updateCurrentPosition(
        position.coords.latitude,
        position.coords.longitude
      );
    });
  };

  renderCurrentPosition = () => {
    if (!this.props.currentPosition) return false;

    return (
      <Marker
        latitude={this.props.currentPosition.latitude}
        longitude={this.props.currentPosition.longitude}
      >
        <Pin
          onClick={() => {
            this.setState({
              popupStatus: 'user'
            });
          }}
        />
      </Marker>
    );
  };

  renderPopUp = () => {
    const { popupStatus, popupStory } = this.state;
    const { currentPosition } = this.props;

    if (!popupStatus) return false;

    if (popupStatus === 'user') {
      return (
        <Popup
          tipSize={5}
          anchor="top"
          longitude={currentPosition.longitude}
          latitude={currentPosition.latitude}
          onClose={() => this.setState({ popupStatus: null })}
        >
          <UserCard />
        </Popup>
      );
    } else if (popupStatus === 'story') {
      return (
        <Popup
          tipSize={5}
          anchor="top"
          longitude={popupStory.longitude}
          latitude={popupStory.latitude}
          onClose={() => this.setState({ popupStatus: null })}
        >
          <StoryCard story={popupStory} />
        </Popup>
      );
    }
  };

  renderStoryMarkers = () => {
    return this.props.stories.map(story => (
      <Marker
        latitude={story.latitude}
        longitude={story.longitude}
        key={story.id}
      >
        <Pin
          fill="#36F1CD"
          onClick={() => {
            this.setState({
              popupStatus: 'story',
              popupStory: story
            });
          }}
        />
      </Marker>
    ));
  };

  componentWillMount() {
    this.getCurrentPosition();
  }

  render() {
    return (
      <ReactMapGL
        {...this.state.viewport}
        width={this.props.containerWidth}
        height={this.props.containerHeight}
        mapboxApiAccessToken="pk.eyJ1IjoibWFyaWFuc2VybmEiLCJhIjoiY2phOGtrcW43MDg5MTJxbGl1Nzg3aDA3ZCJ9.xKp2gqw1gEz0d1fmutdUpw"
        mapStyle="mapbox://styles/marianserna/cj9niotu73i7t2rs1mt2t14sy"
        onViewportChange={viewport => {
          this.setState({ viewport });
        }}
      >
        {this.renderCurrentPosition()}
        {this.renderPopUp()}
        {this.renderStoryMarkers()}
      </ReactMapGL>
    );
  }
}

// higher order component:
export default Dimensions()(Map);
