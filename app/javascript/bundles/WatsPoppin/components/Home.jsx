import PropTypes from 'prop-types';
import React from 'react';

import Map from '../components/Map';

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
  }

  render() {
    return (
      <div>
        <Map
          initialLat={this.props.latitude}
          initialLng={this.props.longitude}
        />
      </div>
    );
  }
}
