import PropTypes from 'prop-types';
import React from 'react';

export default class Home extends React.Component {
  static propTypes = {
    // name: PropTypes.string.isRequired
  };

  /**
   * @param props - Comes from your rails view.
   */
  constructor(props) {
    super(props);

    this.state = {};
  }

  render() {
    return <div>map and realtime imported here</div>;
  }
}
