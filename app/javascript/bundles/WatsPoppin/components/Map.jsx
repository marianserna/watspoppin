import React from 'react';
import PropTypes from 'prop-types';
import ReactMapGL from 'react-map-gl';

export default class Map extends React.Component {
  static propTypes = {
    name: PropTypes.string.isRequired
  };

  constructor(props) {
    super(props);

    this.state = {
      viewport: {
        width: window.innerWidth,
        height: window.innerHeight,
        latitude: 37.7577,
        longitude: -122.4376,
        zoom: 10
      }
    };
  }

  render() {
    return (
      <div>
        <ReactMapGL
          {...this.state.viewport}
          mapboxAccessToken="pk.eyJ1IjoibWFyaWFuc2VybmEiLCJhIjoiY2phOGtrcW43MDg5MTJxbGl1Nzg3aDA3ZCJ9.xKp2gqw1gEz0d1fmutdUpw"
          mapStyle="mapbox://styles/marianserna/cj9niotu73i7t2rs1mt2t14sy"
          onViewportChange={viewport => {
            this.setState({ viewport });
          }}
        />
      </div>
    );
  }
}
