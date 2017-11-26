import Search from './Search';
import { spy } from 'sinon';

// react geosuggest requires google maps api to be on the window as well as an instance of google geocoder: https://github.com/ubilabs/react-geosuggest/blob/master/src/Geosuggest.jsx - componentWillMount(line 82)
global.window.google = {
  maps: {
    places: {
      AutocompleteService: class AutocompleteService {}
    },
    Geocoder: class Geocoder {}
  }
};

const currentPosition = { latitude: 43.6532, longitude: -79.3832 };

describe('Search', () => {
  it('calls search prop when form is submitted', () => {
    const search = spy();

    const wrapper = mount(
      <Search search={search} currentPosition={currentPosition} />
    );

    wrapper
      .find('form')
      .first()
      .simulate('submit');

    expect(search.called).toBe(true);
  });
});
