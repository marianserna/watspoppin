import PropTypes from 'prop-types';
import React from 'react';

import Map from '../components/Map';

export default class Home extends React.Component {
  static propTypes = {};

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
        <Map />
      </div>
    );
  }
}
