import UserCard from './UserCard';

// Test when there's a user
it('renders user card when user is present', () => {
  const user = {
    image: {
      thumb: { url: '/luigi.jpg' }
    },
    name: 'Maria Antonieta de las Nieves'
  };

  const userCard = render(<UserCard user={user} />);
  expect(userCard).toMatchSnapshot();
});

// Test when there's no user
it('renders user card when user is null', () => {
  const user = null;

  const userCard = render(<UserCard user={user} />);
  expect(userCard).toMatchSnapshot();
});
