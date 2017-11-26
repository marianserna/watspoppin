import Realtime from './Realtime';
import { spy } from 'sinon';

const stories = [
  {
    id: 30,
    image: { thumb: { url: '/mario.jpg' } },
    content:
      'Locavore mumblecore XOXO seitan, jean shorts williamsburg flannel pickled',
    handle: 'Gorvachov puff puff'
  }
];

const trending_hashtags = ['dog', 'cat', 'bunny'];

describe('Realtime', () => {
  it('Renders correctly', () => {
    const search = spy();

    const wrapper = render(
      <Realtime
        stories={stories}
        trending_hashtags={trending_hashtags}
        search={search}
      />
    );

    expect(wrapper).toMatchSnapshot();
  });

  it('Calls search when a trend is clicked', () => {
    const search = spy();

    const wrapper = mount(
      <Realtime
        stories={stories}
        trending_hashtags={trending_hashtags}
        search={search}
      />
    );

    wrapper
      .find('.trend_link')
      .first()
      .simulate('click');

    expect(search.called).toBe(true);
  });

  it('Changes state#collapsed on click', () => {
    const wrapper = shallow(
      <Realtime
        stories={stories}
        trending_hashtags={trending_hashtags}
        search={() => {}}
      />
    );

    expect(wrapper.state().collapsed).toBe(true);

    wrapper
      .find('.trends')
      .first()
      .simulate('click', { preventDefault: () => {} });

    expect(wrapper.state().collapsed).toBe(false);
  });
});
