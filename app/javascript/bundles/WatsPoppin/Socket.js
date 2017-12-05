import ActionCable from 'actioncable';

export default class Socket {
  constructor() {
    this.cable = ActionCable.createConsumer('/cable');
  }
  // onNewStories function comes from home component
  setupSubscription = (onNewStories, latitude, longitude) => {
    this.subscription = this.cable.subscriptions.create(
      {
        channel: 'StoriesChannel',
        latitude,
        longitude
      },
      {
        received: (data) => {
          console.log('received data');
          console.log(data);
          // function receives new data and updates the state
          onNewStories(data);
        }
      }
    );
  };

  update = (lat, lng) => {
    this.subscription.send({
      latitude: lat,
      longitude: lng
    });
  };

  unsubscribe = () => {
    this.subscription.unsubscribe();
  };
}
