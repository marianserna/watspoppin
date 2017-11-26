import StoryCard from './StoryCard';

const story = {
  id: 1,
  content: 'Rapido corren los carros',
  image: {
    thumb: {
      url:
        'https://s7d2.scene7.com/is/image/PetSmart/PB1201_STORY_CARO-Authority-HealthyOutside-DOG-20160818?$PB1201$'
    }
  }
};

it('Renders a figure for the story clicked', () => {
  const wrapper = render(<StoryCard story={story} />);

  expect(wrapper).toMatchSnapshot();
});
