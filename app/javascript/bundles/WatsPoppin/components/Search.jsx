import React from 'react';

export default class Search extends React.Component {
  render() {
    return (
      <div>
        <p>Find out what's going on!</p>
        <form>
          <label htmlFor="hashtag" />
          <input type="text" id="hashtag" placeholder="#hashtag" />
          <input type="text" id="location" placeholder="location" />
          <button type="submit">SERCH</button>
        </form>
      </div>
    );
  }
}
