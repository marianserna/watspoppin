import Pin from './Pin';

it('renders a pin', () => {
  const wrapper = render(<Pin />);
  expect(wrapper).toMatchSnapshot();
});
